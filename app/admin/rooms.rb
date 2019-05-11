ActiveAdmin.register Room do
  # menu priority: 3
  menu parent: "Apartments"
  permit_params :name, :area_dimension, :status, :apartment_id,
                tasks_attributes: [:id, :name, :description, :status, :_destroy]

  controller do
    def update
      update! do |format|
        format.html { redirect_to edit_admin_room_path }
      end
    end
  end

  index do
    selectable_column
    id_column
    column :name
    column :area_dimension
    column :apartment
    column :status
    actions
  end

  form html: { multipart: true } do |f|
    f.inputs 'Room' do
      f.input :name
      f.input :area_dimension
      f.input :status, include_blank: false
      f.input :apartment,
              as: :select,
              include_blank: false,
              collection: Apartment.find_each.collect { |u| [ "#{u.property_name} / #{u.property_developer} / #{u.owner}", u.id ] }
    end

    f.inputs 'Tasks' do
      f.has_many :tasks, heading: '', allow_destroy: true, new_record: 'Add a task' do |ff|
        ff.input :name
        ff.input :status
        ff.input :description, as: :text
      end
    end
    f.actions
  end
end
