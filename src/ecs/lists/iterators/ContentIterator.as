/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.lists.iterators {
import ecs.framework.api.ecs_core;
import ecs.lists.Node;
import ecs.lists.NodeList;

use namespace ecs_core;

/**
 * Node content iterator
 */
public class ContentIterator {
	ecs_core var list:NodeList;
	ecs_core var currentNode:Node;
	ecs_core var currentContent:*;
	
	public function ContentIterator( list:NodeList ) {
		this.list = list;
	}

	[Inline]
	public final function get current():* {
		return currentContent;
	}

	public function next():* {
		currentNode = ( currentNode ? currentNode.next : list.$firstNode );
		currentContent = ( currentNode ? currentNode.content : null );
		return currentContent;
	}

	public function first():* {
		currentNode = list.$firstNode;
		currentContent = ( currentNode ? currentNode.content : null );
		return currentContent;
	}

	public function last():* {
		currentNode = list.$lastNode;
		currentContent = ( currentNode ? currentNode.content : null );
		return currentContent;
	}

	public function dispose():void {
		list = null;
		currentNode = null;
		currentContent = null;
	}
}
}
