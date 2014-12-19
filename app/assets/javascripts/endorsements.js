$(document).ready(function() {
  console.log('doc ready')
  $('.endorsements-link').on('click', function(event){
    event.preventDefault();
    console.log('clicked')

    var endorsementCount = $(this).siblings('.endorsements_count');

    $.post(this.href, function(response){
    endorsementCount.text(response.new_endorsement_count);
    console.log('tried to update count and show')
    })
  })

})
