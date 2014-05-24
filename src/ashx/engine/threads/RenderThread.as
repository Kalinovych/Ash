/*
 * Copyright (c) 2014, FlashRushGames.com
 * @author Alexander Kalinovych
 */
package ashx.engine.threads {
import ashx.engine.api.IRenderProcess;

public class RenderThread extends AbstractThread {
	
	public function render():void {
		$forEach( $callRender );
	}

	protected final function $callRender( process:IRenderProcess ):void {
		process.render();
	}
	
}
}
