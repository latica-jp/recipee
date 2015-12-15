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
      element.present? ?
      ActionController::Base.helpers.sanitize(element.inner_html.gsub(/\n/,""), tags: ['br']).gsub(/<br.*?>/,"\n") :
      nil
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
      servings_for = get_content(".servings_for")
      author_name = get_content("#recipe_author_name")
      main_photo_url = get_attr("#main-photo img", "src")
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
        photo_url = get_attr("div.image img", "src", e)
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
  
  def create_clipper(url)
  end
end
