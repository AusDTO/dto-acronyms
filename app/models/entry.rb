class Entry < ActiveRecord::Base
  validates :term, presence: true

  scope :existing, ->{ where(archived: false) }
  scope :archived, ->{ where(archived: true) }
  scope :by_term, ->(term) {
    where('lower(term) = ? OR lower(expanded_term) = ?', term.downcase, term.downcase)
  }

  default_scope -> { order(term: :asc) }

  def archive!
    update_attributes!(archived: true)
  end

  def full_term
    expanded_term.present? ? expanded_term : term
  end

end
