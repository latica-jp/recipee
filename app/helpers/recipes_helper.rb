module RecipesHelper
  require 'open-uri'
  require 'nokogiri'

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
      title = get_content("h1.recipe-title")
      description = get_content(".summary .description_text")
      servings_for = get_content(".servings_for")
      author_name = get_content("#recipe_author_name")
      main_photo_url = get_attr("#main-photo img", "src")
      {title: title, description: description, author_name: author_name, 
        ref_url: @url, servings_for: servings_for, main_photo_url: main_photo_url}
    end
    
    def get_ingredients
      arr_params = Array.new
      get_elements("div.ingredient_row").each do |e|
        # スペーサーやカテゴリをスキップ
        if e.css("div.ingredient_name").present?
          name = get_content("div.ingredient_name span.name", e)
          quantity_for = get_content("div.ingredient_quantity", e)
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
        arr_params.push({text: text, photo_url: photo_url, row_order: row_order})
      end
      arr_params
    end

    private
    
    def get_content(tag_css, element = nil)
      clip if !element && !@doc
      element = element ||= @doc
      ActionController::Base.helpers.sanitize(element.css(tag_css).first.inner_html.gsub(/\n/,""), tags: ['br']).gsub(/<br.*?>/,"\n")
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
end
