ActiveAdmin.register Task do
  # menu priority: 4
  menu parent: "Apartments"
  permit_params :name, :description, :room_id

  controller do
    def update
      update! do |format|
        format.html { redirect_to edit_admin_task_path }
      end
    end
  end

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
