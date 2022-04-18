class TracksController < ApplicationController
  before_action :set_track, only: %i[show]

  def index
    @tracks = Track.all
    tracks_json = TrackSerializer.new(@tracks, is_collection: true).serializable_hash.to_json

    render json: tracks_json, status: :ok
  end

  def show
    track_json = TrackSerializer.new(@track).serializable_hash.to_json

    render json: track_json, status: :ok
  end

  private

  def set_track
    @track = Track.find(params[:id])
  end
end
