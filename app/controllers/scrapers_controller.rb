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
    host = URI(params[:url]).host
    scrapers = Scraper.for_host(host)
    raise "Invalid host" if scrapers.empty?
    result = ScraperService.new(@scraper).get_price(params[:url])
    render json: { price: result }, status: :ok
  end

  private

  def update_associations
    update_hosts
    update_rules
  end

  def update_hosts
    unless hosts_params[:hosts].nil?
      @scraper.hosts.clear
      hosts_params[:hosts].each do |host|
        @scraper.hosts << Host.new(host)
      end
    end
  end

  def update_rules
    unless rules_params[:rules].nil?
      @scraper.rules.clear
      rules_params[:rules].each do |rule|
        @scraper.rules << Rule.new(rule)
      end
    end
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
