// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require rails.validations
//= require twitter/bootstrap
//= require dataTables/jquery.dataTables
//= require dataTables/jquery.dataTables.bootstrap
//= require_tree .

(function() {
  $.extend($.fn.dataTableExt.oStdClasses, {
   "sStripeOdd": "",
   "sStripeEven": "",
  });

  $(document).ready(function() {
    $('.datatable').each(function() {
      var data = $(this).data()
      var options = {
        "sDom": "<'row'<'span6'l><'span6'f>r>t<'row'<'span6'i><'span6'p>>",
        "sPaginationType": "bootstrap",
        "bInfo": data.info === undefined ? true : data.info,
        "bPaginate": data.paginate === undefined ? true : data.paginate,
        "bSort": data.sort === undefined ? true : data.sort,
        "bFilter": data.filter === undefined ? true : data.filter
      }
      $(this).dataTable(options)
    })
  });
  $(document).ready(function() {
    return $("div.control-group").focusout(function() {
      if (!$("div.control-group").hasClass("error")) {
        return $(this).addClass("success");
      }
    });
  });
}).call(this);

ClientSideValidations.formBuilders['SimpleForm::FormBuilder'] = {
  add: function(element, settings, message) {
    var errorElement, wrapper;

    settings.wrapper_tag = ".control-group";
    settings.error_tag = "span";
    settings.error_class = "help-inline";
    settings.wrapper_error_class = "error";
    settings.wrapper_success = "success";

    if (element.data('valid') !== false) {
      wrapper = element.closest(settings.wrapper_tag);
      wrapper.removeClass(settings.wrapper_success);
      wrapper.addClass(settings.wrapper_error_class);
      errorElement = $("<" + settings.error_tag + "/>", {
        "class": settings.error_class,
        text: message
      });
      return wrapper.find(".controls").append(errorElement);
    } else {
      wrapper = element.closest(settings.wrapper_tag);
      wrapper.addClass(settings.wrapper_error_class);
      return element.parent().find("" + settings.error_tag + "." + settings.error_class).text(message);
    }
  },
  remove: function(element, settings) {
    var errorElement, wrapper;

    settings.wrapper_tag = ".control-group";
    settings.error_tag = "span";
    settings.error_class = "help-inline";
    settings.wrapper_error_class = "error";
    settings.wrapper_success = "success";

    wrapper = element.closest("" + settings.wrapper_tag + "." + settings.wrapper_error_class);
    wrapper.removeClass(settings.wrapper_error_class);
    wrapper.addClass(settings.wrapper_success);
    errorElement = wrapper.find("" + settings.error_tag + "." + settings.error_class);
    return errorElement.remove();
  }
};
