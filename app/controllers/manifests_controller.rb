class ManifestsController < ApplicationController
  respond_to :html
  respond_to :json, only: :show
  respond_to :sh, only: :show

  expose :manifests, ->{ Manifest.all }
  expose! :manifest, find_by: :uuid, id: ->{ params[:uuid] }

  def create
    manifest.save
    respond_with(manifest)
  end

  def destroy
    manifest.destroy
    redirect_to root_path
  end

  private

  def manifest_params
    params.permit(:domain)
  end
end
