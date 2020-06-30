class RankingController < ApplicationController
  layout 'review_site'
  before_action :ranking

  def ranking
    ranked_ids = Review.group(:product_id).order('count_product_id DESC')
                 .limit(5).count(:product_id).keys
    @ranking = ranked_ids.map{ |id| Product.find(id) }
  end
end
