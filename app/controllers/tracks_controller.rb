class TrackController < ApplicationController

  def create
    @track = Track.new(track_params)
  end

  def destroy
    @track = Track.find(params[:id])
    @track.destroy
  end

  private

  def track_params
    params.require(:track).permit(:name, :id)
  end

end
