ActiveAdmin.register Room do
  # menu priority: 3
  menu parent: "Apartments"
  permit_params :name, :area_dimension, :status, :apartment_id,
                plans: [], render_photos: [], customer_photos: [], documents: [],
                tasks_attributes: [:id, :name, :description, :status, :_destroy]

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

  show do
    attributes_table do
      row :name
      row :area_dimension
      row :status
      row :apartment_id do
        room.apartment
      end
      row :plans do
        ul class: 'show_element' do
          room.plans.each do |plan|
            span class: 'popup-plans' do
              if plan.variable?
                link_to (image_tag plan.variant(resize: '100x100!')), rails_blob_path(plan)
              end
            end
          end
        end
      end
      row :render_photos  do
        ul class: 'show_element' do
          room.render_photos.each do |render_photo|
            span class: 'zoom-gallery' do
              if render_photo.variable?
                link_to (image_tag render_photo.variant(resize: '100x100!')), rails_blob_path(render_photo)
              end
            end
          end
        end
      end
      row :customer_photos  do
        ul class: 'show_element' do
          room.customer_photos.each do |customer_photo|
            span class: 'zoom-gallery' do
              if customer_photo.variable?
                link_to (image_tag customer_photo.variant(resize: '100x100!')), rails_blob_path(customer_photo)
              end
            end
          end
        end
      end
      row :documents  do
        ul class: 'show_element' do
          room.documents.each do |document|
            span do
              if document.previewable?
                link_to (image_tag document.preview(resize: '100x100!')), rails_blob_path(document), class: 'iframe-popup'
              end
            end
          end
        end
      end
    end
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
      f.input :plans, as: :file, input_html: { multiple: true }
      if f.object.plans.attached?
        div class: 'attached_preview' do
          f.object.plans.each do |plan|
            div class: 'attached_element' do
              if plan.variable?
                div class: 'zoom-gallery' do
                  li link_to (image_tag(plan.variant(resize: '200x200!'))), rails_blob_path(plan)
                end
              else
                li link_to 'Download image', rails_blob_path(plan), target: :blank
              end
              li link_to 'Remove', delete_elem_admin_room_path(plan.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        li link_to 'Remove all plans', destroy_multiple_admin_rooms_path(elem_ids: f.object.plans.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end

      f.input :render_photos, as: :file, input_html: { multiple: true }
      if f.object.render_photos.attached?
        ul class: 'attached_preview' do
          f.object.render_photos.each do |render_photo|
            div class: 'attached_element' do
              if render_photo.variable?
                div class: 'zoom-gallery' do
                  li link_to (image_tag(render_photo.variant(resize: '200x200!'))), rails_blob_path(render_photo), target: :blank
                end
              else
                li link_to 'Download image', rails_blob_path(render_photo), target: :blank
              end
              # span check_box_tag "checked_ids[]", photo.id, false, class: 'selectable'
              span link_to 'Remove', delete_elem_admin_room_path(render_photo.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        # span link_to 'Remove checked photos', destroy_multiple_admin_apartments_path(elem_ids: params[:checked_ids], resource_id: f.object.id), method: :delete, class: 'button del_button'
        span link_to 'Remove all photos', destroy_multiple_admin_rooms_path(elem_ids: f.object.render_photos.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end

      f.input :customer_photos, as: :file, input_html: { multiple: true }
      if f.object.customer_photos.attached?
        ul class: 'attached_preview' do
          f.object.customer_photos.each do |customer_photo|
            div class: 'attached_element' do
              if customer_photo.variable?
                div class: 'zoom-gallery' do
                  li link_to (image_tag(customer_photo.variant(resize: '200x200!'))), rails_blob_path(customer_photo), target: :blank
                end
              else
                li link_to 'Download image', rails_blob_path(customer_photo), target: :blank
              end
              # span check_box_tag "checked_ids[]", photo.id, false, class: 'selectable'
              span link_to 'Remove', delete_elem_admin_room_path(customer_photo.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        # span link_to 'Remove checked photos', destroy_multiple_admin_apartments_path(elem_ids: params[:checked_ids], resource_id: f.object.id), method: :delete, class: 'button del_button'
        span link_to 'Remove all photos', destroy_multiple_admin_rooms_path(elem_ids: f.object.customer_photos.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
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
              li link_to 'Remove', delete_elem_admin_room_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        li link_to 'Remove all documents', destroy_multiple_admin_rooms_path(elem_ids: f.object.documents.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end
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
