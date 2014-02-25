package com.reeltrack.utilities;

import com.monumental.trampoline.component.CompCMEntity;

public abstract class ContentPositionable extends CompCMEntity{

	public abstract void setId(int id);
	public abstract void setForeignKeyId(int fkID);
	public abstract void setPosition(int position);

	public abstract int getId();
	public abstract int getForeignKeyId();
	public abstract int getPosition();

}