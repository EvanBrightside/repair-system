ActiveAdmin.register Apartment do
  menu priority: 2
  permit_params :owner, :address, :property_name, :property_developer,
                :status, :number_of_rooms, :floor, :area_dimension,
                plans: [], photos: [], documents: [],
                rooms_attributes: [:id, :name, :area_dimension, :status, :_destroy]

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

  show do
    attributes_table do
      row :owner
      row :address do
        span apartment.address
        unless apartment.geo_coords(apartment.address).nil?
          span ' | '
          span link_to 'Open Google Map', ("https://maps.google.com/maps?q=#{apartment.geo_coords(apartment.address)[:lat]}, #{apartment.geo_coords(apartment.address)[:lon]}"), class: "popup-geo"
        end
      end
      row :property_name
      row :property_developer
      row :status
      row :number_of_rooms
      row :floor
      row :area_dimension
      row :plans do
        ul class: 'show_element' do
          apartment.plans.each do |plan|
            span class: 'popup-plans' do
              if plan.variable?
                link_to (image_tag plan.variant(resize: '100x100!')), rails_blob_path(plan)
              end
            end
          end
        end
      end
      row :photos  do
        ul class: 'show_element' do
          apartment.photos.each do |photo|
            span class: 'zoom-gallery' do
              if photo.variable?
                link_to (image_tag photo.variant(resize: '100x100!')), rails_blob_path(photo)
              else
                link_to "Photo №#{photo.id}", rails_blob_path(photo), target: :blank
              end
            end
          end
        end
      end
      row 'Documents', :documents  do
        ul class: 'show_element' do
          apartment.documents.each do |document|
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
  end

  form html: { multipart: true } do |f|
    f.inputs 'Apartment' do
      f.input :owner
      f.input :address
      f.input :property_name
      f.input :property_developer
      f.input :status, include_blank: false
      f.input :number_of_rooms
      f.input :floor
      f.input :area_dimension
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
              li link_to 'Remove', delete_elem_admin_apartment_path(plan.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        li link_to 'Remove all plans', destroy_multiple_admin_apartments_path(elem_ids: f.object.plans.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end

      f.input :photos, as: :file, input_html: { multiple: true }
      if f.object.photos.attached?
        ul class: 'attached_preview' do
          f.object.photos.each do |photo|
            div class: 'attached_element' do
              if photo.variable?
                div class: 'zoom-gallery' do
                  li link_to (image_tag(photo.variant(resize: '200x200!'))), rails_blob_path(photo), target: :blank
                end
              else
                li link_to 'Download image', rails_blob_path(photo), target: :blank
              end
              # span check_box_tag "checked_ids[]", photo.id, false, class: 'selectable'
              span link_to 'Remove', delete_elem_admin_apartment_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        # span link_to 'Remove checked photos', destroy_multiple_admin_apartments_path(elem_ids: params[:checked_ids], resource_id: f.object.id), method: :delete, class: 'button del_button'
        span link_to 'Remove all photos', destroy_multiple_admin_apartments_path(elem_ids: f.object.photos.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
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
              li link_to 'Remove', delete_elem_admin_apartment_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
            end
          end
        end
        li link_to 'Remove all documents', destroy_multiple_admin_apartments_path(elem_ids: f.object.documents.ids, resource_id: f.object.id), method: :delete, class: 'button del_button'
      end
    end

    f.inputs 'Rooms' do
      f.has_many :rooms, heading: '', allow_destroy: true, new_record: 'Add a room' do |ff|
        ff.input :name
        ff.input :area_dimension
        ff.input :status, include_blank: false
        ff.input :apartment, as: :select, include_blank: false, collection: [
          [ "#{f.object.property_name} / #{f.object.property_developer} / #{f.object.owner}", f.object.id ]
        ]
        ff.input :plans, as: :file, input_html: { multiple: true }
        # div class: 'nested_attrs' do
        #   if ff.object.plans.attached?
        #     ul class: 'attached_preview' do
        #       ff.object.plans.each do |plan|
        #         div class: 'attached_element' do
        #           if plan.variable?
        #             div class: 'zoom-gallery' do
        #               li link_to (image_tag(plan.variant(resize: '100x100!'))), rails_blob_path(plan), target: :blank
        #             end
        #           else
        #             li link_to 'Download image', rails_blob_path(plan), target: :blank
        #           end
        #           span link_to 'Remove', delete_elem_admin_apartment_path(plan.id), method: :delete, data: { confirm: 'Are you sure?' }
        #         end
        #       end
        #     end
        #     span link_to 'Remove all plans', destroy_multiple_admin_apartments_path(elem_ids: ff.object.plans.ids, resource_id: ff.object.id), method: :delete, class: 'button del_button'
        #   end
        # end
        ff.input :render_photos, as: :file, input_html: { multiple: true }
        # div class: 'nested_attrs' do
        #   if ff.object.render_photos.attached?
        #     ul class: 'attached_preview' do
        #       ff.object.render_photos.each do |photo|
        #         div class: 'attached_element' do
        #           if photo.variable?
        #             div class: 'zoom-gallery' do
        #               li link_to (image_tag(photo.variant(resize: '100x100!'))), rails_blob_path(photo), target: :blank
        #             end
        #           else
        #             li link_to 'Download image', rails_blob_path(photo), target: :blank
        #           end
        #           span link_to 'Remove', delete_elem_admin_apartment_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
        #         end
        #       end
        #     end
        #     span link_to 'Remove all render photos', destroy_multiple_admin_apartments_path(elem_ids: ff.object.render_photos.ids, resource_id: ff.object.id), method: :delete, class: 'button del_button'
        #   end
        # end
        ff.input :customer_photos, as: :file, input_html: { multiple: true }
        # div class: 'nested_attrs' do
        #   if ff.object.customer_photos.attached?
        #     ul class: 'attached_preview' do
        #       ff.object.customer_photos.each do |photo|
        #         div class: 'attached_element' do
        #           if photo.variable?
        #             div class: 'zoom-gallery' do
        #               li link_to (image_tag(photo.variant(resize: '100x100!'))), rails_blob_path(photo), target: :blank
        #             end
        #           else
        #             li link_to 'Download image', rails_blob_path(photo), target: :blank
        #           end
        #           span link_to 'Remove', delete_elem_admin_apartment_path(photo.id), method: :delete, data: { confirm: 'Are you sure?' }
        #         end
        #       end
        #     end
        #     span link_to 'Remove all customer photos', destroy_multiple_admin_apartments_path(elem_ids: ff.object.customer_photos.ids, resource_id: ff.object.id), method: :delete, class: 'button del_button'
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
        #           li link_to 'Remove', delete_elem_admin_apartment_path(document.id), method: :delete, data: { confirm: 'Are you sure?' }
        #         end
        #       end
        #     end
        #     li link_to 'Remove all documents', destroy_multiple_admin_apartments_path(elem_ids: ff.object.documents.ids, resource_id: ff.object.id), method: :delete, class: 'button del_button'
        #   end
        # end
      end
    end
    f.actions
  end
end
