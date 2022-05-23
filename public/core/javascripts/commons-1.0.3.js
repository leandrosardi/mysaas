var commonsJs = {

	/*
	 * Spintax regex pattern.
	 *  
	 */
	SPINTAX_PATTERN: /\{[^"\r\n\}]*\}/,
	SPINTAX_PATTERN_GLOBAL: /\{[^"\r\n\}]*\}/g,

	/*
	 * Returns the version of this commonsJs library.
	 *  
	 */
	version: function() {
		return '1.0.4';
	},

	/*
	 * Remove character entities.
	 * Reference: https://stackoverflow.com/questions/7394748/whats-the-right-way-to-decode-a-string-that-has-special-html-entities-in-it
	 *  
	 */
	decodeHtml: function(html) {
		var txt = document.createElement("textarea");
		txt.innerHTML = html;
		return txt.value;
	},

	/*
	 * Convert HTML text to plain text.
	 * Reference: https://dev.to/sanchithasr/3-ways-to-convert-html-text-to-plain-text-52l8
	 *  
	 */
	convertToPlain: function(html) {
		// Create a new div element
		var tempDivElement = document.createElement("div");
		// Set the HTML content with the given value
		tempDivElement.innerHTML = html;
		// Retrieve the text property of the element 
		return tempDivElement.textContent || tempDivElement.innerText || "";
	},

	/*
	 * Returns true if a value is not null and is not undefined.
	 * 
	 * Reference:
	 * https://www.tutorialrepublic.com/faq/how-to-determine-if-variable-is-undefined-or-null-in-javascript.php
	 *
	 */
	isDefined: function(value) {
		var ret = true;
		// Since null === undefined is false, the following statements will catch only null or undefined
		if(typeof value === 'undefined') {
			ret = false;
		} else if(value === null){
			ret = false;
		}
		return ret;
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
	 * Validate if string has a valid spintax formatting.
	 * Nested spintax is not supported.
	 * 
	 */
	isValidSpintax: function(spintax) {
		ret = true;
		count = 0;
		for (var i = 0; i < spintax.length; i++) {
  			if (spintax.charAt(i) == '{') { count += 1; }
  			if (spintax.charAt(i) == '}') { count -= 1; }
  			if (count<0) { ret = false; }
  			if (count>1) { ret = false; }
		}
		if (count!=0) { ret = false; }
		return ret;
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
		var match = '';
		while (match = spintax.match(commonsJs.SPINTAX_PATTERN)) {
			match = match[0];
			var candidates = match.substring(1, match.length - 1).split("|");
			spintax = spintax.replace(match, candidates[Math.floor(Math.random() * candidates.length)]);
		}
		return spintax;
	},

	/*
	 * Returns the largest sample of a spintax.
	 * 
	 */
	removeInvisibleChars: function(content) {
		// replace not-visible chars
		content = content.replace(/\r/g, "");
		content = content.replace(/\n/g, "");
		content = content.replace(/\t/g, "");
		return content;
	},

	/*
	 * Returns the largest sample of a spintax.
	 * 
	 */
	spintaxLargestSample: function(spintax) {
		var match = '';
		// 
		while (match = spintax.match(commonsJs.SPINTAX_PATTERN)) {
			match = match[0];
			var candidates = match.substring(1, match.length - 1).split("|");
			var largest_candidate = candidates.reduce(
				function (a, b) {
					return a.length > b.length ? a : b;
				}
			);
			spintax = spintax.replace(match, largest_candidate);
		}
		return spintax;
	},

	/*
	 * Returns the length if the largestvariation of a spintax.
	 * 
	 */
	spintaxMaxLenght: function(spintax) {
		// get the length of the largest spintax
		return commonsJs.spintaxLargestSample(spintax).length;
	},

	/*
	 * Returns the number of possible variations of a spintax.
	 * 
	 */
	spintaxVariationsCount: function(spintax) {
		var ret = 1;
		var matches = spintax.match(commonsJs.SPINTAX_PATTERN_GLOBAL);
		var i = 0;
		if ( matches == null ) {
			ret = 1;
		} else {
			while (i<matches.length) {
				match = matches[i];
				var candidates = match.substring(1, match.length - 1).split("|");
				ret = ret * candidates.length;
				i++;
			}
		}
		return ret;
	},

}; // var commonsJs = {
