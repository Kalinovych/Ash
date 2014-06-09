/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ecs.engine.threads {
import ecs.engine.processes.api.IRenderProcess;

public class RenderThread extends AbstractThread {
	
	public function render():void {
		$forEach( $callRender );
	}

	protected final function $callRender( process:IRenderProcess ):void {
		process.render();
	}
	
}
}
