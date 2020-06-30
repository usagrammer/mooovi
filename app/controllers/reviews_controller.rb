class ReviewsController < RankingController
  before_action :authenticate_user!, only: :new

  def new
    @product = Product.find(params[:product_id])
    @review = Review.new
  end

  def create
    Review.create(create_params)
    # トップページにリダイレクトする
    redirect_to controller: :products, action: :index
  end

  private
  def create_params
    params.require(:review).permit(:review, :rate)
    .merge(product_id: params[:product_id], user_id: current_user.id)
  end
end
