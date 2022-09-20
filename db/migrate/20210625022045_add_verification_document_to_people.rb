class AddVerificationDocumentToPeople < ActiveRecord::Migration[5.2]
  def change
  	add_column :people, :verification_document_file_name, :string
    add_column :people, :verification_document_content_type, :string
    add_column :people, :verification_document_file_size, :integer
    add_column :people, :verification_document_updated_at, :datetime
  end
end
