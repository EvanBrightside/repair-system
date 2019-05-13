ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation,
                :first_name, :last_name

  controller do
    def update
      update! do |format|
        format.html { redirect_to edit_admin_user_path }
      end
    end
  end

  index do
    selectable_column
    id_column
    column :email
    column :full_user_name
    actions
  end

  filter :email

  form do |f|
    f.inputs do
      f.input :first_name
      f.input :last_name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
