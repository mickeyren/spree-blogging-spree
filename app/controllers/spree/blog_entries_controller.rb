class Spree::BlogEntriesController < Spree::StoreController
  helper 'spree/blog_entries'

  before_action :init_pagination, only: [:index, :tag, :archive, :author, :category]
  # rescue_from ActiveRecord::RecordNotFound, with: render_404

  def index
    @blog_entries = Spree::BlogEntry.visible.page(@pagination_page).per(@pagination_per_page)
    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  def show
    if try_spree_current_user.try(:has_spree_role?, "admin")
      @blog_entry = Spree::BlogEntry.find_by_permalink!(params[:slug])
    else
      @blog_entry = Spree::BlogEntry.visible.find_by_permalink!(params[:slug])
    end

    @title = @blog_entry.title
    @more_blog_entries = Spree::BlogEntry.visible.published_after(@blog_entry.published_at).limit(1)
    @previous_blog_entry = @more_blog_entries.first || Spree::BlogEntry.visible.first
    @next_blog_entry = Spree::BlogEntry.visible.published_before(@blog_entry.published_at).first || Spree::BlogEntry.visible.last
  end

  def tag
    @blog_entries = Spree::BlogEntry.visible.by_tag(params[:tag]).page(@pagination_page).per(@pagination_per_page)
    @tag_name = params[:tag]
  end

   def categories
     @categories = Spree::BlogEntry.category_counts
  end

  def category
    @blog_entries = Spree::BlogEntry.visible.by_category(params[:category]).page(@pagination_page).per(@pagination_per_page)
    @category_name = params[:category]
  end

  def archive
    @blog_entries = Spree::BlogEntry.visible.by_date(params).page(@pagination_page).per(@pagination_per_page)
  end

  def feed
    @blog_entries = Spree::BlogEntry.visible.limit(20)
    render layout: false
  end

  def author
    @author = Spree.user_class.where(nickname: params[:author]).first
    @blog_entries = Spree::BlogEntry.visible.by_author(@author).page(@pagination_page).per(@pagination_per_page)
  end

  private

    def init_pagination
      @pagination_page = params[:page].to_i > 0 ? params[:page].to_i : 1
      @pagination_per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 10
    end
end
