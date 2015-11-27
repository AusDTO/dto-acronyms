class EntriesController < ApplicationController
  def index
  end

  def archived
    @entries = Entry.archived
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(entry_params)

    if entry.save
      flash.notice = 'Entry created'
      redirect_to entry_path(entry)
    else
      render action: :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if entry.update_attributes(entry_params)
      flash.notice = 'Entry saved'
      redirect_to entry_path(entry)
    else
      render action: :new
    end
  end

  def destroy
    entry.archive!

    flash.notice = 'Entry sent to trash'
    redirect_to entries_path
  end

private
  def entry
    @entry ||= Entry.find(params[:id])
  end
  helper_method :entry

  def presented_entry
    EntryPresenter.new(entry)
  end
  helper_method :presented_entry

  def entries
    @entries ||= Entry.existing
  end
  helper_method :entries

  def entries_grouped_by_letter
    entries.group_by {|e|
      e.full_term[0]
    }
  end
  helper_method :entries_grouped_by_letter

  def entry_params
    params.require(:entry).permit(:term, :definition, :expanded_term)
  end

end
