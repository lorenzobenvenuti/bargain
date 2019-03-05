class ScrapersController < ApplicationController
  before_action :set_scraper, only: [:show, :update, :destroy]

  def index
    json_response(Scraper.all)
  end

  def create
    @scraper = Scraper.new(scraper_params)
    update_hosts
    @scraper.save!
    render json: @scraper, include: [:hosts], status: :created
  end

  def show
    json_response(@scraper)
  end

  def update
    update_hosts
    @scraper.update(scraper_params)
    head :no_content
  end

  def destroy
    @scraper.destroy
    head :no_content
  end

  private

  def update_hosts
    @scraper.hosts.clear
    unless hosts_params[:hosts].nil?
      hosts_params[:hosts].each do |host|
        puts "Host #{host}"
        @scraper.hosts << Host.new(host)
      end
    end
  end

  def scraper_params
    params.permit(:name, :price_selector, :price_regex)
  end

  def hosts_params
    params.permit(hosts: [:host])
  end

  def set_scraper
    @scraper = Scraper.find(params[:id])
  end
end
