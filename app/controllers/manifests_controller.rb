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
    respond_with(manifest, location: root_path)
  end

  private

  def manifest_params
    params.require(:manifest).permit(
      ssh: { key: [:fingerprint] },
      app: [:name, :domains, services: []],
      platform: [:version],
      hosting: [server: [:image, :size, :region]],
      dns: [:domain],
      providers: [digitalocean: [:token]]
    )
  end
end
