class CategoriesController < InheritedResources::Base
before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  private

    def category_params
      params.require(:category).permit(:title)
    end
    
    
end
