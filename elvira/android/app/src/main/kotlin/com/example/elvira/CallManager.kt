package com.example.elvira

import android.content.Context
import android.media.AudioManager
import android.telecom.Call
import io.flutter.plugin.common.EventChannel

object CallManager {
    var currentCall: Call? = null
    var pendingCallerName: String = ""
    var pendingCallerNumber: String = ""

    private var sink: EventChannel.EventSink? = null
    private val pending = mutableListOf<Map<String, Any?>>()

    fun setSink(value: EventChannel.EventSink?) {
        sink = value
        if (value != null) {
            pending.forEach { value.success(it) }
            pending.clear()
        }
    }

    fun notify(event: Map<String, Any?>) {
        val s = sink
        if (s != null) s.success(event) else pending.add(event)
    }

    fun disconnect() = currentCall?.disconnect()

    fun setSpeaker(ctx: Context, on: Boolean) {
        val am = ctx.getSystemService(Context.AUDIO_SERVICE) as AudioManager
        @Suppress("DEPRECATION")
        am.isSpeakerphoneOn = on
    }

    fun currentState(): String? = currentCall?.let { stateLabel(it.state) }

    fun stateLabel(state: Int): String = when (state) {
        Call.STATE_RINGING -> "ringing"
        Call.STATE_DIALING -> "dialing"
        Call.STATE_ACTIVE -> "active"
        Call.STATE_HOLDING -> "holding"
        Call.STATE_DISCONNECTED -> "disconnected"
        Call.STATE_DISCONNECTING -> "disconnecting"
        else -> "unknown"
    }
}
