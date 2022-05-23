var commonsJs = {
	/*
	 * Returns the version of this commonsJs library.
	 *  
	 */
	version: function() {
		return '1.0.2';
	},

	/*
	 * Replaces every HTML reserved char by its regarding HTML entity.
	 *
	 * Reference:
	 * https://www.html.am/reference/html-special-characters.cfm
	 * 
	 * Source: 
	 * https://stackoverflow.com/questions/5499078/fastest-method-to-escape-html-tags-as-html-entities 
	 */
	replaceTag: function(tag) {
		var tagsToReplace = {
		    '"': '&34;',
		    "'": '&39;',
		    '&': '&amp;',
		    '<': '&lt;',
		    '>': '&gt;',
		};
	    return tagsToReplace[tag] || tag;
	},
	escapeHTML: function(s) {
	    return s.replace(/["'&<>]/g, commonsJs.replaceTag);
	},

	/*
	 * Replaces every HTML entity regarding an HTML reserved char by such reserved char.
	 *
	 * Reference:
	 * https://www.html.am/reference/html-special-characters.cfm
	 * 
	 * Source: 
	 * https://stackoverflow.com/questions/5499078/fastest-method-to-escape-html-tags-as-html-entities 
	 */
	unReplaceTag: function(tag) {
		var tagsToReplace = {
		   	'&34;': '"',
			'&39;': "'",
		    '&amp;': '&',
		    '&lt;': '<',
		  	'&gt;': '>',
		};
	    return tagsToReplace[tag] || tag;
	},
	unEscapeHTML: function(s) {
	    return s.replace(/&34;|&39;|&amp;|&lt;|&gt;/g, commonsJs.unReplaceTag);
	},

	/*
	 * Converts spintax to a random rotation/sample.
	 * It doesn't support nested spintax.
	 * 
	 * Example:
	 * "Our {brand new|exclusive|unique|new}  {service|product} {was|is} {crafted|created|designed} to <!benefit1!write the most attractive benefit of your service!>"
	 * may be converted to
	 * "Our brand new product is created to <!benefit1!write the most attractive benefit of your service!>"
	 * 
	 */
	spin: function(spintax) {
		var SPINTAX_PATTERN = /\{[^"\r\n\}]*\}/;
		var match = '';
		while (match = spintax.match(SPINTAX_PATTERN)) {
			match = match[0];
			var candidates = match.substring(1, match.length - 1).split("|");
			spintax = spintax.replace(match, candidates[Math.floor(Math.random() * candidates.length)]);
		}
		return spintax;
	},
}; // var commonsJs = {
