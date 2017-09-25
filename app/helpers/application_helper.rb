module ApplicationHelper
  def bootstrap_class_for(flash_type)
    hash = {
      alert: "alert-danger",
      notice: "alert-success"
    }

    hash.fetch(flash_type.to_sym, flash_type)
  end
end
