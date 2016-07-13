$(document).ready(function() {
	$('div').on('click', 'a.destroy_banner_style', function(e) {
		e.preventDefault();
		$(this).parent().remove();
	});
	
	$('div').on('click', 'a.destroy_new_banner_styles', function(e) {
		e.preventDefault();
		$(this).closest('.new_banner_styles').remove();
	});

	// Handle adding new styles
	var styles_hash_index = 1;
	$('#form_admin_banner_box_settings').on('click', 'a.add_new_banner_style', function(e) {
		e.preventDefault();
		styles_hash_index++;
		$('#new-banner-styles').append(generate_html_for_hash('new_banner_styles', styles_hash_index));
	});

	// Generates html for new paperclip styles form fields
	generate_html_for_hash = function(hash_name, index) {
		var html = '<div class="' + hash_name + ' row">';
		html += '<div class="col-md-5 col-sm-4"><div class="form-group">';
	    html += '<label for="' + hash_name + '_' + index + '_name">' + Spree.translations.name + '</label>';
	    html += '<input id="' + hash_name + '_' + index + '_name" name="' + hash_name + '[' + index + '][name]" type="text" class="form-control">';
	    html += '</div></div>';
	    html +=	'<div class="col-md-4 col-sm-4"><div class="form-group">';
	    html += '<label for="' + hash_name + '_' + index + '_value">' + Spree.translations.value + '</label>';
	    html += '<input id="' + hash_name + '_' + index + '_value" name="' + hash_name + '[' + index + '][value]" type="text" class="form-control">';
	    html += '</div></div>';
	    html +=	'<div class="col-md-3 col-sm-4"><div class="form-group">';
	    html += '<label style="visibility: hidden;">Deletar</label>';
	    html += '<a href="#" role="button" title="' + Spree.translations.destroy + '" class="destroy_' + hash_name + ' btn btn-primary form-control"><i class="icon icon-trash"></i> &nbsp; ' + Spree.translations.destroy + '</a>';
	    html += '</div></div>';
	    html += '</div>';

	    index += 1;
	    return html;
	};
	
	$('.with-tip').tooltip('destroy');
});
