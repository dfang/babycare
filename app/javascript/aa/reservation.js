import $ from 'jquery'

$(function () {

  $(document).on("click", "#symptom-tags .pills-list .badge", function (e) {
    $(e.target)
      .siblings()
      .removeClass("active")
      .end()
      .toggleClass("active");
    tag = $(e.target).text();
    details = [];
    for (var i = 0, len = symptom_tag_details.length; i < len; i++) {
      if (symptom_tag_details[i].name == tag) {
        details = symptom_tag_details[i].values;
      }
    }
    $("#symptom-tag-details")
      .parents(".weui-cell")
      .removeClass("hide");
    $("#symptom-tag-details").empty();
    $("#symptom-tag-details").tags({
      values: details,
      templates: {
        pill: '<span class="badge badge-info tag-badge" data-tag-id="{1}" style="overflow: hidden; white-space: nowrap;" class="tag-remove">{0}</span>',
        number: "<sup><small>{0}</small></sup>"
      },
      input_name: "tag_list[]",
      can_delete: false,
      can_add: false
    });
  });

  $(document).on("click", "#symptom-tag-details .pills-list .badge", function (e) {
    $(e.target).toggleClass("active");
    details = [];
    $(e.target)
      .parent(".pills-list")
      .find(".badge.active")
      .map(function (i, e) {
        details.push($(e).text());
      });

    text = "大夫您好, 我的宝宝, ";

    console.log(text + details);
    $(".weui-cell-remark .weui-textarea").val(text + details);
  });

  $(".simple_form.new_reservation")
    .parsley({
      uiEnabled: true,
      errorsWrapper: ""
    })
    .on("field:error", function () {
      $(this.$element)
        .parents(".weui-cell")
        .addClass("validation_error");
    })
    .on("field:success", function () {
      $(this.$element)
        .parents(".weui-cell")
        .removeClass("validation_error");
    });

})
