ActiveAdmin.register Room do
  permit_params :name, :area_dimension, :status, :apartment_id,
                tasks_attributes: [:id, :name, :description, :status, :_destroy]

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

  # f.inputs 'Tasks' do
  #   f.has_many :tasks, heading: '', allow_destroy: true, new_record: 'Add a task' do |ff|
  #     ff.input :name
  #     ff.input :description
  #   end
  # end
end
