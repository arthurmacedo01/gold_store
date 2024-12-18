# frozen_string_literal: true

module SolidusAdmin
  class TaxonomiesController < SolidusAdmin::BaseController
    include SolidusAdmin::ControllerHelpers::Search

    before_action :load_taxonomy, only: [ :move ]

    def index
      taxonomies = apply_search_to(
        Spree::Taxonomy.accessible_by(current_ability),
        param: :q,
      )

      set_page_and_extract_portion_from(taxonomies)

      respond_to do |format|
        format.html { render component("taxonomies/index").new(page: @page) }
      end
    end

    def move
      @taxonomy.insert_at(params[:position].to_i)

      respond_to do |format|
        format.js { head :no_content }
      end
    end

    def destroy
      @taxonomies = Spree::Taxonomy.where(id: params[:id])

      Spree::Taxonomy.transaction { @taxonomies.destroy_all }

      flash[:notice] = t(".success")
      redirect_back_or_to taxonomies_path, status: :see_other
    end

    private

    def load_taxonomy
      @taxonomy = Spree::Taxonomy.find(params[:id])
      authorize! action_name, @taxonomy
    end
  end
end
