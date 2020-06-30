class Scraping
  def self.movie_urls
    #linksという配列の空枠を作る
    links = []
    #Mechanizeクラスのインスタンスを生成する
    agent = Mechanize.new

    # socket error 対策
    # agent = Mechanize.new do |a|
    #   a.keep_alive = false
    # end


    #パスの部分を変数で定義
    next_url = ""

    while true
      #映画の全体ページのURLを取得
      current_page = agent.get("http://review-movie.herokuapp.com/" + next_url)
      #全体ページから映画20件の個別URLのタグを取得
      erements = current_page.search('.entry-title a')
      #個別URLのタグからhref要素を取り出し、links配列に格納する
      erements.each do |ele|
        links << ele[:href]
      end
      #「次へ」を表すタグを取得
      next_link_ele = current_page.at('.pagination .next a')
      # next_linkがなかったらwhile文を抜ける
      break unless next_link_ele
      # そのタグからhref属性の値を取得
      next_url = next_link_ele[:href]
    end
    #get_productを実行する際にリンクを引数として渡す
    links.each do |link|
      get_product("http://review-movie.herokuapp.com/" + link)
    end

  end

  def self.get_product(link)
    #Mechanizeクラスのインスタンスを生成する
    # agent = Mechanize.new

    # agent = Mechanize.new

    agent = Mechanize.new
    agent.keep_alive = false

    #映画の個別ページのURLを取得
    page = agent.get(link)
    #inner_textメソッドを利用し映画のタイトルを取得
    title = page.at('.entry-title').inner_text
    #image_url, director, detail, open_dateが存在すれば取り出す
    image_url = page.at('.entry-content img')[:src] if page.at('.entry-content img')
    director = page.at('.director span').inner_text if page.at('.director span')
    detail = page.at('.entry-content p').inner_text if page.at('.entry-content p')
    open_date = page.at('.date span').inner_text    if page.at('.date span')
    #Productsテーブルをtitle: titleで検索し、あれば取得、なければnew
    product = Product.where(title: title).first_or_initialize
    #image_url, director, detail, open_dateを代入
    product.image_url = image_url
    product.director  = director
    product.detail    = detail
    product.open_date = open_date
    product.save
  end
end
