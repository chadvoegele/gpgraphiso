#!/usr/bin/env python

from __future__ import division
from scipy import integrate
import npreader2.dbreader
import npreader2.nvconstants as nvc

def get_gpu_power_samples(nvprof):
    nvp = npreader2.dbreader.NVProfile(nvprof)
    
    out = []
    for m in nvp.environment():
        if m['environmentKind'] == nvc.CUPTI_ACTIVITY_ENVIRONMENT_POWER:
            d = m.data()
            out.append({'timestamp_ns': m['timestamp'], 
                        'power_mw': d.power,
                        'powerLimit_mw': d.powerLimit})
            

    out.sort(key=lambda x: x['timestamp_ns'])
    return out

def get_gpu_energy(samples):
    orig = samples[0]['timestamp_ns']
    power_w = [s['power_mw'] / 1E3 for s in samples]
    time_s = [(s['timestamp_ns'] - orig) / 1E9 for s in samples]

    avg = sum(power_w) / len(power_w)
    p1 = avg * (time_s[-1] - time_s[0])
    p2 = integrate.trapz(power_w, time_s)

    return (p1, p2)

if __name__ == "__main__":
    import argparse

    p = argparse.ArgumentParser(description="Get GPU power statistics")
    p.add_argument("nvprof", help="NVprof file")

    args = p.parse_args()

    samples = get_gpu_power_samples(args.nvprof)
    energy = get_gpu_energy(samples)

    if True:
        for s in samples:
            print "%f,%f" % (s['timestamp_ns'] / 1E9, s['power_mw'] / 1E3)

    print "Energy (from avg): %0.2f Joules" % (energy[0],)
    print "Energy (by integration): %0.2f Joules" % (energy[1],)
    print "Total runtime: %d ns" % (samples[-1]['timestamp_ns'] - samples[0]['timestamp_ns'])
