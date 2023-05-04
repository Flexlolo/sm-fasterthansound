/*
COMPILE OPTIONS
*/

#pragma semicolon 1
#pragma newdecls required

/*
INCLUDES
*/

#include <sourcemod>
#include <lololib>

/*
PLUGIN INFO
*/

public Plugin myinfo = 
{
	name			= "Faster than speed",
	author			= "Flexlolo",
	description		= "Creates cool speed effect",
	version			= "1.0.0",
	url				= "github.com/Flexlolo/"
}

/*
GLOBAL VARIABLES
*/

char g_sOverlay[MAXPLAYERS + 1][128];

/*
NATIVES AND FORWARDS
*/

public void OnPluginStart()
{
	HookEvent("player_death", Event_Player_Death);
}

public void OnClientConnected(int client)
{
	g_sOverlay[client] = "0";
}

/*
COMMANDS
*/

public Action Event_Player_Death(Event event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(event.GetInt("userid"));

	if (lolo_IsClientValid(client, true))
	{
		SetOverlay(client, "0");
	}
	
	return Plugin_Continue;
}

public void SetOverlay(int client, const char[] overlay)
{
	if (!StrEqual(g_sOverlay[client], overlay))
	{
		ClientCommand(client, "r_screenoverlay %s", overlay);
		strcopy(g_sOverlay[client], sizeof(g_sOverlay[]), overlay);
	}

	for (int i = 1; i <= MaxClients; i++)
	{
		if (lolo_IsClientValid(i) && !IsPlayerAlive(i))
		{
			if (lolo_GetClientSpecTarget(i) == client)
			{
				if (!StrEqual(g_sOverlay[i], overlay))
				{
					ClientCommand(i, "r_screenoverlay %s", overlay);
					strcopy(g_sOverlay[i], sizeof(g_sOverlay[]), overlay);
				}
			}
		}
	}
}

public Action OnPlayerRunCmd(int client, int& buttons, int& impulse, float vel[3], float angles[3], int& weapon, int& subtype, int& cmdnum, int& tickcount, int& seed, int mouse[2])
{
	if (lolo_IsClientValid(client, true) && IsPlayerAlive(client))
	{
		float vector[3];
		lolo_GetClientAbsVelocity(client, vector);
		vector[2] = 0.0;
		float velocity = GetVectorLength(vector);

		if (velocity >= 1000.0)
		{
			SetOverlay(client, "Effects/tp_eyefx/tpeye2");
		}
		else if (velocity >= 600.0)
		{
			SetOverlay(client, "Effects/tp_eyefx/tpeye");
		}
		else
		{
			SetOverlay(client, "0");
		}
	}

	return Plugin_Continue;
}


