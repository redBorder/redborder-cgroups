require_relative 'rb_update_cgroups'
unless RedBorder::Checker.check_memservices_cgroups() # When any memservice is wrongly assigned
    `rb_configure_cgroups`
end