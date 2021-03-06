class ArticlesController < ApplicationController
  before_action :set_article, only: [:show, :edit, :update, :destroy]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  # GET /articles
  def index
    @q = Article.ransack(params[:q])
    @articles = policy_scope(@q.result).page params[:page]
  end

  # GET /articles/1
  def show
    cnt = @article.view_count + 1
    @article.update_attribute 'view_count', cnt
  end

  # GET /articles/new
  def new
    @article = Article.new
    @article.author = current_user
    authorize @article
  end

  # GET /articles/1/edit
  def edit
  end

  # POST /articles
  def create
    @article = Article.new(article_params)
    @article.author = current_user
    authorize @article

    if @article.save
      redirect_to @article, notice: 'Article was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /articles/1
  def update
    if @article.update(article_params)
      redirect_to @article, notice: 'Article was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /articles/1
  def destroy
    @article.destroy
    redirect_to articles_url, notice: 'Article was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.find(params[:id])
    authorize @article
  end

  # Only allow a list of trusted parameters through.
  def article_params
    params.require(:article).permit(:title, :is_published, :content)
  end
end
