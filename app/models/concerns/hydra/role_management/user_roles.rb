module Hydra
  module RoleManagement
    module UserRoles
      extend ActiveSupport::Concern
      included do
        has_and_belongs_to_many :roles
      end

      def groups
        g = roles.map(&:name)
        g += ['registered'] unless new_record? || guest?
        g
      end

      def guest?
        if defined?(DeviseGuests)
          read_attribute :guest
        else
          false
        end
      end

      def admin?
        roles.where(name: 'admin').exists?
      end

      def agency_submitters?
        roles.where(name: 'agency_submitters').exists?
      end

      def library_reviewers?
        roles.where(name: 'library_reviewers').exists?
      end
    end
  end
end