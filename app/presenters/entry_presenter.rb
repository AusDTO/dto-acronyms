require 'delegate'

class EntryPresenter < SimpleDelegator

  def definition_with_links
    definition.tap {|definition|
      # Choose the entries which aren't acronyms first, so that we can replace
      # the most specific matches before anything else.
      entries_to_match.reject {|e| e.expanded_term.present? }.each do |e|
        add_links_to_term!(definition, e.term, e)
      end

      entries_to_match.select {|e| e.expanded_term.present? }.each do |e|
        add_links_to_term!(definition, e.expanded_term, e)
        add_links_to_term!(definition, e.term, e)
      end
    }
  end


private
  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  def entry
    __getobj__
  end

  def entries_to_match
    # Exclude the current entry so that we're not linking to ourselves, and then
    # sort the entries so that the longest entry gets replaced first - this way
    # we can ensure we're always linking to the most specific term.
    #
    Entry.all.reject {|e|
      e == entry
    }.sort_by {|e|
      e.full_term.length
    }.reverse
  end

  def expr_for_term(string)
    naive_stem = string.sub(/s$/, '')
    term = Regexp.escape(naive_stem)

    adjacent_escape_pattern = "[^a-zA-Z0-9\-\"<>]"

    Regexp.new("(#{adjacent_escape_pattern}|^)(#{term}s?)(#{adjacent_escape_pattern}|$)", true)
  end

  def add_links_to_term!(definiton, term, entry)
    definition.gsub!(
      expr_for_term(term),
      "\\1" + link_to_term("\\2", entry) + "\\3"
    )
  end

  def link_to_term(string, destination_entry)
    link_to(string, entry_path(destination_entry), title: destination_entry.full_term)
  end

end
