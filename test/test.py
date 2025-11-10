# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer


async def i2c_start(dut):
    """Generate I2C start condition: SDA goes low while SCL is high"""
    await RisingEdge(dut.uio_in[1])
    await Timer(2.5, unit="us")
    dut.uio_in[0].value = 0


async def i2c_stop(dut):
    """Generate I2C stop condition: SDA goes high while SCL is high"""
    await FallingEdge(dut.uio_in[1])
    await Timer(2.5, unit="us")
    dut.uio_in[0].value = 0
    await RisingEdge(dut.uio_in[1])
    await Timer(2.5, unit="us")
    dut.uio_in[0].value = 1


async def i2c_write_byte(dut, byte):
    """Write a byte on the I2C bus"""
    for i in range(7, -1, -1):
        await FallingEdge(dut.uio_in[1])  # wait for SCL low
        await Timer(2.5, unit="us")
        dut.uio_in[0].value = (byte >> i) & 1
    # Release SDA for ACK
    await FallingEdge(dut.uio_in[1])
    await Timer(2.5, unit="us")
    dut.uio_in[0].value = 1


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start test")

    # Create system clock 1 MHz
    cocotb.start_soon(Clock(dut.clk, 5000, unit="ns").start())

    # Create external I2C clock 100 kHz (uio_in[1])
    async def i2c_clock():
        while True:
            val = int(dut.uio_in.value)
            val |= (1 << 1)
            dut.uio_in.value = val
            await Timer(5, unit="us")
            val &= ~(1 << 1)
            dut.uio_in.value = val
            await Timer(5, unit="us")

    cocotb.start_soon(i2c_clock())

    # Reset
    dut.rst_n.value = 0
    dut.ena.value = 0
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    
    # SDA idle high
    val = int(dut.uio_in.value)
    val |= 1 << 0   # set bit 0
    dut.uio_in.value = val
    
    await Timer(2, unit="us")
    dut.rst_n.value = 1
    dut.ena.value = 1

    # Direct pass-through test
    dut.ui_in.value = 0xA5
    await Timer(10, unit="us")
    await i2c_start(dut)
    await i2c_write_byte(dut, 0b10001110)
    await i2c_write_byte(dut, 0x00)
    await i2c_write_byte(dut, 0x01)
    await i2c_stop(dut)
    await Timer(10, unit="us")

    dut.ui_in.value = 0x0A
    await Timer(10, unit="us")
    dut.ui_in.value = 0xFF
    await Timer(10, unit="us")

    # Test multiple register writes
    for reg, val in zip(range(8, 16), [0x11,0x22,0x33,0x44,0x55,0x66,0x77,0x88]):
        await i2c_start(dut)
        await i2c_write_byte(dut, 0b10001110)
        await i2c_write_byte(dut, reg)
        await i2c_write_byte(dut, val)
        await i2c_stop(dut)

    dut.ui_in.value = 0xF0
    await Timer(10, unit="us")

    # Additional register writes like in original TB
    await i2c_start(dut)
    await i2c_write_byte(dut, 0b10001110)
    await i2c_write_byte(dut, 0x00)
    await i2c_write_byte(dut, 0xF2)
    await i2c_stop(dut)

    await Timer(1000, unit="us")

    await i2c_start(dut)
    await i2c_write_byte(dut, 0b10001110)
    await i2c_write_byte(dut, 0x00)
    await i2c_write_byte(dut, 0x01)
    await i2c_stop(dut)

    await Timer(100, unit="us")

    await i2c_start(dut)
    await i2c_write_byte(dut, 0b10001110)
    await i2c_write_byte(dut, 0x01)
    await i2c_write_byte(dut, 0x0F)
    await i2c_stop(dut)

    await i2c_start(dut)
    await i2c_write_byte(dut, 0b10001110)
    await i2c_write_byte(dut, 0x00)
    await i2c_write_byte(dut, 0xF2)
    await i2c_stop(dut)

    await Timer(10000, unit="us")

    dut._log.info("Test finished")
