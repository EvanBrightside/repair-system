ActiveAdmin.register Subtask do
  menu parent: "Apartments", priority: 3
  permit_params :name, :description, :status,
                :deadline, :author, :executor,
                :task_id, render_photos: [],
                customer_photos: [], documents: []

  member_action :delete_elem, method: :delete do
    elem = ActiveStorage::Attachment.find(params[:id])
    elem.purge
    redirect_back(fallback_location: edit_admin_apartment_path)
  end

  collection_action :destroy_multiple, method: :delete do
    ActiveStorage::Attachment.find(params[:elem_ids]).each do |elem|
      elem.purge
    end
    redirect_back(fallback_location: edit_admin_apartment_path(params[:resource_id]))
  end

  index do
    selectable_column
    id_column
    column :name
    column :status
    column :deadline
    column :author do |task|
      User.find(task.author.to_i).full_user_name unless task.author.empty?
    end
    column :executor do |task|
      User.find(task.executor.to_i).full_user_name unless task.executor.empty?
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :status
      row :deadline
      row :author do |task|
        User.find(task.author.to_i).full_user_name unless task.author.empty?
      end
      row :executor do |task|
        User.find(task.executor.to_i).full_user_name unless task.author.empty?
      end
      row :render_photos  do
        ul class: 'show_element' do
          task.render_photos.each do |photo|
            span class: 'zoom-gallery' do
              if photo.variable?
                link_to (image_tag photo.variant(resize: '100x100!')), rails_blob_path(photo)
              else
                link_to "Render photo №#{photo.id}", rails_blob_path(photo), target: :blank
              end
            end
          end
        end
      end
      row :customer_photos  do
        ul class: 'show_element' do
          task.customer_photos.each do |photo|
            span class: 'zoom-gallery' do
              if photo.variable?
                link_to (image_tag photo.variant(resize: '100x100!')), rails_blob_path(photo)
              else
                link_to "Customer photo №#{photo.id}", rails_blob_path(photo), target: :blank
              end
            end
          end
        end
      end
      row 'Documents', :documents  do
        ul class: 'show_element' do
          task.documents.each do |document|
            span do
              if document.previewable?
                link_to (image_tag document.preview(resize: '100x100!')), rails_blob_path(document), class: 'iframe-popup'
              else
                li link_to 'Download file', rails_blob_path(document), target: :blank
              end
            end
          end
        end
      end
    end
    active_admin_comments
  end

  form html: { multipart: true } do |f|
    f.inputs 'Subtask' do
      f.input :name
      f.input :description, as: :text
      f.input :status, include_blank: false
      f.input :deadline, as: :datepicker
      f.input :author, include_blank: false, collection: [[ "#{current_user.full_user_name}", current_user.id ]]
      f.input :executor, as: :select, include_blank: false, collection: User.find_each.collect { |u| [ "#{u.full_user_name}", u.id ] }
      f.input :task,
              as: :select,
              include_blank: false,
              collection: Task.find_each.collect { |u| [ "#{u.name}", u.id ] }
      f.input :render_photos, as: :file, input_html: { multiple: true }
      if f.object.render_photos.attached?
        ul class: 'attached_preview' do
          f.object.render_photos.each do |photo|
            div class: 'attached_element' do
              if photo.variable?
                div class: 'zoom-gallery' do
                  li link_to (image_tag(photo.variant(resize: '200x200!'))), rails_blob_path(photo), target: :blank
                end
              else
                li link_to 'Download image', rails_blob_path(photo), target: :blank
              end
              # span check_box_tag "checked_ids[]", photo.id, false, class: 'selectable'
              span link_to 'Remove', delete_elem_admin_task_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        # span link_to 'Remove checked photos', destroy_multiple_admin_apartments_path(elem_ids: params[:checked_ids], resource_id: f.object.id), method: :delete, class: 'button del_button'
        span link_to 'Remove all render photos', destroy_multiple_admin_tasks_path(elem_ids: f.object.render_photos.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end

      f.input :customer_photos, as: :file, input_html: { multiple: true }
      if f.object.customer_photos.attached?
        ul class: 'attached_preview' do
          f.object.customer_photos.each do |photo|
            div class: 'attached_element' do
              if photo.variable?
                div class: 'zoom-gallery' do
                  li link_to (image_tag(photo.variant(resize: '200x200!'))), rails_blob_path(photo), target: :blank
                end
              else
                li link_to 'Download image', rails_blob_path(photo), target: :blank
              end
              # span check_box_tag "checked_ids[]", photo.id, false, class: 'selectable'
              span link_to 'Remove', delete_elem_admin_task_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        # span link_to 'Remove checked photos', destroy_multiple_admin_apartments_path(elem_ids: params[:checked_ids], resource_id: f.object.id), method: :delete, class: 'button del_button'
        span link_to 'Remove all customer photos', destroy_multiple_admin_tasks_path(elem_ids: f.object.customer_photos.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end

      f.input :documents, as: :file, input_html: { multiple: true }
      if f.object.documents.attached?
        ul class: 'attached_preview' do
          f.object.documents.map do |document|
            div class: 'attached_element' do
              if document.previewable?
                li link_to (image_tag(document.preview(resize: '200x200!'))), rails_blob_path(document), class: 'iframe-popup'
              else
                li link_to 'Download file', rails_blob_path(document), target: :blank
              end
              li link_to 'Remove', delete_elem_admin_task_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        li link_to 'Remove all documents', destroy_multiple_admin_tasks_path(elem_ids: f.object.documents.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end
    end
    f.actions
  end
end
