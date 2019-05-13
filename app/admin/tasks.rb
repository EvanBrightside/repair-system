ActiveAdmin.register Task do
  menu parent: "Apartments", priority: 2
  permit_params :name, :description, :status,
                :tag, :deadline, :author, :executor,
                :room_id, render_photos: [],
                customer_photos: [], documents: [],
                subtasks_attributes: [
                  :id, :name, :description, :status,
                  :tag, :deadline, :author, :executor,
                  :_destroy, render_photos: [],
                  customer_photos: [], documents: []
                ]

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
    column :author
    column :executor
    actions
  end

  show do
    attributes_table do
      row :name
      row :status
      row :deadline
      row :author
      row :executor
      row :render_photos  do
        ul class: 'show_element' do
          task.render_photos.each do |photo|
            span class: 'zoom-gallery' do
              if photo.variable?
                link_to (image_tag photo.variant(resize: '100x100!')), rails_blob_path(photo)
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
              end
            end
          end
        end
      end
    end
    active_admin_comments
  end

  form html: { multipart: true } do |f|
    f.inputs 'Task' do
      f.input :name
      f.input :description, as: :text
      f.input :status, include_blank: false
      f.input :deadline, as: :datepicker
      f.input :author
      f.input :executor
      f.input :room,
              as: :select,
              include_blank: false,
              collection: Room.find_each.collect { |u| [ "#{u.name}", u.id ] }
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

    f.inputs 'Subtasks' do
      f.has_many :subtasks, heading: '', allow_destroy: true, new_record: 'Add a subtask' do |ff|
        ff.input :name
        ff.input :status
        ff.input :description, as: :text
        ff.input :author
        ff.input :executor
        ff.input :deadline, as: :datepicker
        ff.input :task, as: :select, include_blank: false, collection: [[ "#{f.object.name}", f.object.id ]]
        ff.input :render_photos, as: :file, input_html: { multiple: true }
        ff.input :customer_photos, as: :file, input_html: { multiple: true }
        # div class: 'nested_attrs' do
        #   if ff.object.photos.attached?
        #     ul class: 'attached_preview' do
        #       ff.object.photos.each do |photo|
        #         div class: 'attached_element' do
        #           if photo.variable?
        #             div class: 'zoom-gallery' do
        #               li link_to (image_tag(photo.variant(resize: '100x100!'))), rails_blob_path(photo), target: :blank
        #             end
        #           else
        #             li link_to 'Download image', rails_blob_path(photo), target: :blank
        #           end
        #           span link_to 'Remove', delete_elem_admin_task_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
        #         end
        #       end
        #     end
        #     span link_to 'Remove all photos', destroy_multiple_admin_tasks_path(elem_ids: ff.object.photos.ids, resource_id: ff.object.id), method: :delete, class: 'button del_button'
        #   end
        # end
        ff.input :documents, as: :file, input_html: { multiple: true }
        # div class: 'nested_attrs' do
        #   if ff.object.documents.attached?
        #     ul class: 'attached_preview' do
        #       ff.object.documents.map do |document|
        #         div class: 'attached_element' do
        #           if document.previewable?
        #             li link_to (image_tag(document.preview(resize: '100x100!'))), rails_blob_path(document), class: 'iframe-popup'
        #           else
        #             li link_to 'Download file', rails_blob_path(document), target: :blank
        #           end
        #           li link_to 'Remove', delete_elem_admin_task_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
        #         end
        #       end
        #     end
        #     li link_to 'Remove all documents', destroy_multiple_admin_tasks_path(elem_ids: ff.object.documents.ids, resource_id: ff.object.id), method: :delete, class: 'button del_button'
        #   end
        # end
      end
    end
    f.actions
  end
end
