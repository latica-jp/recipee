module RecipesHelper
  require 'open-uri'
  require 'nokogiri'

  # 抽象クラス
  class Clipper
    
    def initialize(url)
      @url = url
    end
        
    def recipe_params
      param = get_recipe
      param[:recipe_ingredients_attributes] = get_ingredients
      param[:recipe_steps_attributes] = get_steps
      param
    end
    
    def get_recipe
    end
    
    def get_ingredients
    end

    def get_steps
    end

    protected
    
    def get_content(tag_css, element = nil)
      clip if !element && !@doc
      element = element ||= @doc
      element = element.css(tag_css).first
      element.present? ? sanitize_ex(element.inner_html) : nil
    end
    
    def get_attr(tag_css, attr_name, element = nil)
      clip if !element && !@doc
      element = element ||= @doc
      element.css(tag_css).first.try(:attr, attr_name)
    end
    
    def get_elements(tag_css)
      clip if !@doc
      @doc.css(tag_css)
    end
    
    def sanitize_ex(line)
      ActionController::Base.helpers.sanitize(line.gsub(/\n/,""), tags: ['br']).gsub(/<br.*?>/,"\n").gsub(/^\s*|\s*$/, "")
    end
    
    def clip
      charset = nil
      begin
        html = open(@url) do |f|
          charset = f.charset #文字種別を取得
          f.read #htmlを読み込んで変数htmlに渡す
        end
        #htmlをパース(解析)してオブジェクトを作成
        @doc = Nokogiri::HTML.parse(html, nil, charset)
      rescue OpenURI::HTTPError => e
        if e.message == '404 Not Found'
          # handle 404 error
        else
          raise e
        end
      end
    end
  end
  
  # Cookpadさん
  class CookpadClipper < Clipper
    def get_recipe
      title = get_content("h1.recipe-title")
      description = get_content(".summary .description_text")
      /（(.*?)）/ =~ get_content(".servings_for")
      servings_for = $1
      author_name = get_content("#recipe_author_name")
      main_photo_url = get_attr("#main-photo img", "data-large-photo")
      {title: title, description: description, author_name: author_name, 
        ref_url: @url, servings_for: servings_for, remote_image_url: main_photo_url}
    end
    
    def get_ingredients
      arr_params = Array.new
      get_elements("div.ingredient_row").each do |e|
        # スペーサーやカテゴリをスキップ
        if e.css("div.ingredient_name").present?
          name = get_content("div.ingredient_name span.name", e)
          quantity_for = get_content("div.ingredient_quantity", e)
          # remote_image_url: carrierwave 経由で画像をダウンロード
          arr_params.push({name: name, quantity_for: quantity_for, row_order: arr_params.length + 1})
        end
      end
      arr_params
    end

    def get_steps
      arr_params = Array.new
      get_elements("div.step, div.step_last").each do |e|
        row_order = e.attr("data-position")
        text = get_content("p.step_text", e)
        photo_url = get_attr("div.image img", "data-large-photo", e)
        # remote_image_url: carrierwave 経由で画像をダウンロード
        arr_params.push({text: text, remote_image_url: photo_url, row_order: row_order})
      end
      arr_params
    end    
  end
  
  # 楽天レシピさん
  class RakutenClipper < Clipper
    def get_recipe
      title = get_content("div.detailHead h1[itemprop=name]")
      description = get_content("div.detailArea p.summary")
      servings_for = get_content("div.materialBox span[itemprop=recipeYield]")
      author_name = get_content("div.ownerThumb span[itemprop=name]")
      main_photo_url = get_attr("div.rcpPhotoBox img", "src")
      {title: title, description: description, author_name: author_name, 
        ref_url: @url, servings_for: servings_for, remote_image_url: main_photo_url}
    end
    
    def get_ingredients
      arr_params = Array.new
      get_elements("li[itemprop=ingredients]").each do |e|
          name = get_content("a", e)
          quantity_for = get_content("p.amount", e)
          # remote_image_url: carrierwave 経由で画像をダウンロード
          arr_params.push({name: name, quantity_for: quantity_for, row_order: arr_params.length + 1})
      end
      arr_params
    end

    def get_steps
      arr_params = Array.new
      get_elements("li.stepBox").each do |e|
        row_order = get_content("h4", e).to_i
        text = get_content("p.stepMemo", e)
        photo_url = get_attr("div.stepPhoto img", "src", e)
        # remote_image_url: carrierwave 経由で画像をダウンロード
        arr_params.push({text: text, remote_image_url: photo_url, row_order: row_order})
      end
      arr_params
    end    
  end
  
  # オレンジページさん
  class OrangepageClipper < Clipper
    def get_recipe
      title = get_content("h1.title").strip
      description = get_content("p[itemprop=summary]").strip
      /（(.*?)）/ =~ get_content("div.recipeDetailFoodsList h2")
      servings_for = $1
      author_name = get_content("span[itemprop=author]")
      main_photo_url = get_attr("img[itemprop=photo]", "src")
      {title: title, description: description, author_name: author_name, 
        ref_url: @url, servings_for: servings_for, remote_image_url: main_photo_url}
    end
    
    def get_ingredients
      arr_params = Array.new
      get_elements("li[itemprop=ingredient]").each do |e|
          name = get_content("span[itemprop=name]", e)
          quantity_for = get_content("span[itemprop=amount]", e)
          # remote_image_url: carrierwave 経由で画像をダウンロード
          arr_params.push({name: name, quantity_for: quantity_for, row_order: arr_params.length + 1})
      end
      arr_params
    end

    def get_steps
      arr_params = Array.new
      i = 0
      get_elements("div[itemprop=instructions] div.direction").each do |e|
        row_order = i += 1
        # 説明文がdiv.direction の子要素になっていない
        text = sanitize_ex(e.next_element.inner_html)
        photo_url = nil # 画像なし
        arr_params.push({text: text, remote_image_url: photo_url, row_order: row_order})
      end
      arr_params
    end    
  end
  
  require 'net/http'
  
  def create_clipper(url)

    # check if URL Valid
    uri = URI.parse(url)
    return nil if uri.host.nil?
    # check is recipe URL
    recipe_url = uri.host + uri.request_uri
    if (recipe_url =~ /^cookpad\.com\/recipe\/\d.*/).present?
      type = :cookpad
    elsif (recipe_url =~ /^www\.orangepage\.net\/recipes\/detail_\d.*/).present?
      type = :orangepage
    elsif (recipe_url =~ /^recipe\.rakuten\.co\.jp\/recipe\/\d.*/).present?
      type = :rakuten
    else
      return nil
    end
    
    # check if page really exists
    Net::HTTP.start(uri.host, uri.port) do |http|
      return nil if http.head(uri.request_uri).code != "200"
    end
    
    if type == :cookpad
      return CookpadClipper.new(url)
    elsif type == :orangepage
      return OrangepageClipper.new(url)
    elsif type == :rakuten
      return RakutenClipper.new(url)
    end
    
    return nil
    
  end
end
