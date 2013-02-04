
$(document).ready(function() {
	$('.add_post .editor ul.controls li').click(function() {
		var textarea = $(this).parentsUntil('.add_post').find('textarea');

		var replacement = textarea.getSelection().text;
		var e = textarea.get(0);
		var indent = 0;

		if($(this).hasClass('i')) {
			indent = 1;
			replacement = '*' + replacement + '*';
		}
		else if($(this).hasClass('b')) {
			indent = 2;
			replacement = '**' + replacement + '**';
		}
		else if($(this).hasClass('q')) {
			indent = 2;
			replacement = replacement.replace(/^/mg, '> ');
		}
		else if($(this).hasClass('url')) {
			var text = replacement !== '' ? replacement : 'link text';
			indent = text.length + 3;
			replacement = '[' + text + '](http://www.example.com)';
		}

		// Moz/Gecko
		if('selectionStart' in e) {
			e.value = e.value.substr(0, e.selectionStart) + replacement + e.value.substr(e.selectionEnd, e.value.length);

			// Move selection
			var start = e.selectionStart;
			var end = e.selectionEnd;

			if($(this).hasClass('q')) {
				if( start == end ) {
					e.selectionStart += indent;
				}
				else {
					e.selectionEnd = end + indent * replacement.match(/^/mg).length;
				}
			}
			else if($(this).hasClass('url')) {
				e.selectionStart = start + indent;
				e.selectionEnd   = start + replacement.length - 1;
			}
			else {
				e.selectionStart = start + indent;
				e.selectionEnd = end + indent;
			}
		}
		// MSIE
		else if(document.selection) {
			e.focus();
			document.selection.createRange().text = replacement;
		}
		// ??
		else {
			e.value += replacement;
		}
	});
});
