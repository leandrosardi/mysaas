function applyReadMore() {
	$('.readmore-link').click(function() {
		$('#'+$(this).data('what-more')).toggle();
		$(this).toggle();
	});
}
