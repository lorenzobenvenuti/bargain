class ScrapersController < ApplicationController
  before_action :set_scraper, only: [:show, :update, :destroy, :test]

  def index
    render json: Scraper.all, include: [:hosts, :rules], status: :ok
  end

  def create
    @scraper = Scraper.new(scraper_params)
    update_associations
    @scraper.save!
    render json: @scraper, include: [:hosts, :rules], status: :created
  end

  def show
    render json: @scraper, include: [:hosts, :rules], status: :ok
  end

  def update
    update_associations
    @scraper.update!(scraper_params)
    head :no_content
  end

  def destroy
    @scraper.destroy
    head :no_content
  end

  def test
    raise 'Must specify an url' if params[:url].nil?
    result = ScraperService.for_scraper(@scraper).get_price(params[:url])
    render json: { price: result }, status: :ok
  end

  private

  def update_associations
    params_to_associations(hosts_params[:hosts], @scraper.hosts) do |h|
      Host.new(h)
    end
    params_to_associations(rules_params[:rules], @scraper.rules) do |r|
      Rule.new(r)
    end
    puts "Scraper rules #{@scraper.rules}"
  end

  def scraper_params
    params.permit(:name)
  end

  def hosts_params
    params.permit(hosts: [:host])
  end

  def rules_params
    params.permit(rules: [:rule_type, :rule_args])
  end

  def set_scraper
    @scraper = Scraper.find(params[:id])
  end
end
