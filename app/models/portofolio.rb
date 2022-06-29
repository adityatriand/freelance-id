class Portofolio < ApplicationRecord
  belongs_to :user

  mount_uploader :porto_attachment, PortoAttachmentUploader
  validates :title, presence: true, length: { maximum: 20 }
  validates :description, presence: true, length: { minimum: 50 }
  validates :type_project, presence: true,  inclusion: { in: %w(personal client) }
  validates :client_name, presence: true, if: :type_client?
  validates :client_industry, presence: true, if: :type_client?
  validates :porto_attachment, presence: true

  def type_client?
    type_project == "client"
  end
end
