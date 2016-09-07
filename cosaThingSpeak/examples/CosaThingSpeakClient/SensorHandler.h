/**
 * @file SensorHandler.h
 * @version 1.0
 *
 * @section License
 * Copyright (C) 2014-2015, Mikael Patel
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * This file is part of the Arduino Che Cosa project.
 */

#ifndef SENSOR_HANDLER_H
#define SENSOR_HANDLER_H

#include "ThingSpeak.hh"
#include "Cosa/Alarm.hh"
#include <DHT.h>

class SensorHandler : public Alarm {
public:
  SensorHandler(ThingSpeak::Channel* channel,
		::Clock* clock,
		Board::ExternalInterruptPin pin,
		uint16_t period) :
  Alarm(clock, period),
    m_channel(channel),
    m_sensor(pin)
  {}
  virtual void run();
private:
  ThingSpeak::Channel* m_channel;
  DHT11 m_sensor;
};

#endif

