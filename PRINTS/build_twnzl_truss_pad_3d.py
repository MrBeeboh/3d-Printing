#!/usr/bin/env python3
"""Vendor Twnzl arm (3D boot kept) + pad cube, print-oriented.

Flat pad back (vendor min-X) on the bed. Irregular shoe (vendor +X) faces up.
"""
from collections import defaultdict
from pathlib import Path

import numpy as np
import trimesh
from trimesh.exchange.export import export_mesh

ARM = Path("/home/mike/Documents/3d_Printing/PRINTS/stl/twnzl_truss_arm_only.stl")
OUT = Path("/home/mike/Documents/3d_Printing/PRINTS/stl/twnzl_truss_pad_3d.stl")
PREVIEW_DIR = Path("/tmp/twnzl_truss_pad_preview")

PAD_X0, PAD_X1 = 2.13, 8.13
PAD_Y0, PAD_Y1 = 8.0, 46.0
PAD_Z0, PAD_Z1 = -46.0, 24.0


def boundary_edges(faces):
    counts = defaultdict(int)
    for f in faces:
        for i in range(3):
            a, b = int(f[i]), int(f[(i + 1) % 3])
            key = (a, b) if a < b else (b, a)
            counts[key] += 1
    return [e for e, n in counts.items() if n == 1]


def ordered_loops(bedges):
    adj = defaultdict(list)
    unused = set(bedges)
    for a, b in bedges:
        adj[a].append(b)
        adj[b].append(a)
    loops = []
    while unused:
        a, b = next(iter(unused))
        unused.remove((a, b))
        loop = [a, b]
        prev, cur = a, b
        while True:
            found = None
            for n in adj[cur]:
                e = (cur, n) if cur < n else (n, cur)
                if e in unused:
                    found = n
                    unused.remove(e)
                    break
            if found is None:
                break
            if found == loop[0]:
                break
            loop.append(found)
            prev, cur = cur, found
        loops.append(loop)
    return loops


def cap_holes(mesh):
    V = np.asarray(mesh.vertices, dtype=np.float64)
    F = np.asarray(mesh.faces, dtype=np.int64)
    bedges = boundary_edges(F)
    loops = ordered_loops(bedges)
    extras_v = []
    extras_f = []
    off = len(V)
    print(f"boundary edges={len(bedges)} loops={[len(l) for l in loops]}")
    for loop in loops:
        if len(loop) < 3:
            continue
        pts = V[np.array(loop)]
        c = pts.mean(axis=0)
        ci = off
        extras_v.append(c)
        off += 1
        n = len(loop)
        for i in range(n):
            extras_f.append([loop[i], loop[(i + 1) % n], ci])
    if extras_v:
        V2 = np.vstack([V, np.vstack(extras_v)])
        F2 = np.vstack([F, np.asarray(extras_f, dtype=np.int64)])
    else:
        V2, F2 = V, F
    closed = trimesh.Trimesh(vertices=V2, faces=F2, process=True)
    trimesh.repair.fix_normals(closed)
    trimesh.repair.fill_holes(closed)
    print(
        f"capped: watertight={closed.is_watertight} volume={closed.is_volume} "
        f"vol={closed.volume:.1f} faces={len(closed.faces)}"
    )
    return closed


def pad_box():
    box = trimesh.creation.box(
        extents=[PAD_X1 - PAD_X0, PAD_Y1 - PAD_Y0, PAD_Z1 - PAD_Z0]
    )
    box.apply_translation(
        [(PAD_X0 + PAD_X1) / 2.0, (PAD_Y0 + PAD_Y1) / 2.0, (PAD_Z0 + PAD_Z1) / 2.0]
    )
    return box


def orient_flat_back_up_shoe(mesh):
    # vendor X -> print Z (shoe up), vendor YZ -> print XY (flat back on bed)
    T = np.array(
        [
            [0.0, 1.0, 0.0, 0.0],
            [0.0, 0.0, 1.0, 0.0],
            [1.0, 0.0, 0.0, 0.0],
            [0.0, 0.0, 0.0, 1.0],
        ]
    )
    mesh.apply_transform(T)
    mesh.apply_translation(-mesh.bounds[0])
    return mesh


def heightmap_fill(mesh, pitch=0.45):
    """Solid under the part: each XY column filled from Z=0 to local max Z."""
    vox = mesh.voxelized(pitch)
    mat = np.asarray(vox.matrix, dtype=bool)
    maxz = np.max(np.where(mat, np.arange(mat.shape[2])[None, None, :], -1), axis=2)
    h = np.where(maxz >= 0, (maxz + 1).astype(np.float64) * pitch, 0.0)
    nx, ny = h.shape
    H = np.zeros((nx + 1, ny + 1), dtype=np.float64)
    H[:-1, :-1] = np.maximum(H[:-1, :-1], h)
    H[1:, :-1] = np.maximum(H[1:, :-1], h)
    H[:-1, 1:] = np.maximum(H[:-1, 1:], h)
    H[1:, 1:] = np.maximum(H[1:, 1:], h)
    ox, oy, _oz = vox.transform[:3, 3]
    xs = ox + np.arange(nx + 1) * pitch
    ys = oy + np.arange(ny + 1) * pitch
    n = (nx + 1) * (ny + 1)
    XX, YY = np.meshgrid(xs, ys, indexing="ij")
    top = np.column_stack([XX.ravel(), YY.ravel(), H.ravel()])
    bot = np.column_stack([XX.ravel(), YY.ravel(), np.zeros(n)])
    V = np.vstack([top, bot])

    def vid(i, j, is_top=True):
        return (0 if is_top else n) + i * (ny + 1) + j

    faces = []
    for i in range(nx):
        for j in range(ny):
            if h[i, j] <= 0:
                continue
            a, b, c, d = vid(i, j), vid(i + 1, j), vid(i + 1, j + 1), vid(i, j + 1)
            faces.extend([[a, b, c], [a, c, d]])
            a2, b2, c2, d2 = vid(i, j, False), vid(i + 1, j, False), vid(i + 1, j + 1, False), vid(i, j + 1, False)
            faces.extend([[a2, d2, c2], [a2, c2, b2]])
            if i == 0 or h[i - 1, j] <= 0:
                t0, t1, b0, b1 = vid(i, j), vid(i, j + 1), vid(i, j, False), vid(i, j + 1, False)
                faces.extend([[t0, t1, b1], [t0, b1, b0]])
            if i == nx - 1 or h[i + 1, j] <= 0:
                t0, t1, b0, b1 = vid(i + 1, j), vid(i + 1, j + 1), vid(i + 1, j, False), vid(i + 1, j + 1, False)
                faces.extend([[t0, b0, b1], [t0, b1, t1]])
            if j == 0 or h[i, j - 1] <= 0:
                t0, t1, b0, b1 = vid(i, j), vid(i + 1, j), vid(i, j, False), vid(i + 1, j, False)
                faces.extend([[t0, b0, b1], [t0, b1, t1]])
            if j == ny - 1 or h[i, j + 1] <= 0:
                t0, t1, b0, b1 = vid(i, j + 1), vid(i + 1, j + 1), vid(i, j + 1, False), vid(i + 1, j + 1, False)
                faces.extend([[t0, t1, b1], [t0, b1, b0]])
    solid = trimesh.Trimesh(vertices=V, faces=np.asarray(faces, dtype=np.int64), process=True)
    solid.update_faces(solid.area_faces > 1e-10)
    solid.remove_unreferenced_vertices()
    trimesh.repair.fix_normals(solid)
    solid.apply_translation([0, 0, -solid.bounds[0][2]])
    print("heightmap fill wt", solid.is_watertight, "vol", solid.volume)
    return solid


def render_previews(mesh):
    PREVIEW_DIR.mkdir(parents=True, exist_ok=True)
    try:
        import matplotlib

        matplotlib.use("Agg")
        import matplotlib.pyplot as plt
        from mpl_toolkits.mplot3d.art3d import Poly3DCollection
    except Exception as e:
        print("matplotlib preview skip:", e)
        return []

    faces = mesh.vertices[mesh.faces]
    # downsample faces for speed if huge
    if len(faces) > 8000:
        idx = np.linspace(0, len(faces) - 1, 8000, dtype=int)
        faces = faces[idx]
    b = mesh.bounds
    mid = (b[0] + b[1]) / 2.0
    ext = (b[1] - b[0]).max()
    views = {
        "iso": ((mid[0] + ext, mid[1] + ext, mid[2] + ext), "iso — shoe up"),
        "top": ((mid[0], mid[1], mid[2] + ext * 2), "top — looking down at shoe"),
        "side": ((mid[0] + ext * 2, mid[1], mid[2]), "side — height is shoe relief"),
    }
    paths = []
    for name, (eye, title) in views.items():
        fig = plt.figure(figsize=(8, 7), facecolor="white")
        ax = fig.add_subplot(111, projection="3d")
        coll = Poly3DCollection(faces, alpha=0.92, linewidths=0.05)
        coll.set_facecolor((0.12, 0.12, 0.13, 1.0))
        coll.set_edgecolor((0.35, 0.35, 0.36, 0.25))
        ax.add_collection3d(coll)
        ax.set_xlim(b[0][0], b[1][0])
        ax.set_ylim(b[0][1], b[1][1])
        ax.set_zlim(b[0][2], b[1][2])
        ax.set_box_aspect(b[1] - b[0])
        ax.view_init(
            elev=20 if name == "iso" else (90 if name == "top" else 0),
            azim=35 if name == "iso" else ( -90 if name == "top" else 0),
        )
        ax.set_xlabel("X mm")
        ax.set_ylabel("Y mm")
        ax.set_zlabel("Z mm")
        ax.set_title(title)
        ax.tick_params(labelsize=7)
        p = PREVIEW_DIR / f"twnzl_truss_pad_3d_{name}.png"
        fig.tight_layout()
        fig.savefig(p, dpi=120)
        plt.close(fig)
        paths.append(p)
        print("preview", p)
    return paths


def main():
    arm = trimesh.load(str(ARM), force="mesh")
    print("arm loaded", arm.bounds, "watertight", arm.is_watertight)
    closed = cap_holes(arm)
    pad = pad_box()
    print("pad watertight", pad.is_watertight, "vol", pad.volume)

    unioned = None
    if closed.is_volume:
        try:
            unioned = trimesh.boolean.union([closed, pad], engine="manifold")
            print("union ok", unioned.volume, "wt", unioned.is_watertight)
        except Exception as e:
            print("union failed:", e)
    if unioned is None:
        # last resort: concatenate overlapping bodies — slicer treats as one object
        unioned = trimesh.util.concatenate([closed, pad])
        print("concat fallback shells", unioned.split().__len__() if False else "?")
        print("concat wt", unioned.is_watertight, "faces", len(unioned.faces))

    unioned = orient_flat_back_up_shoe(unioned)
    # Fill every XY column down to the bed so the 3D shoe can face up
    # without PLA supports. Top contour stays; undersides become solid.
    fill = heightmap_fill(unioned, pitch=0.45)
    try:
        unioned = trimesh.boolean.union([unioned, fill], engine="manifold")
        print("filldown union vol", unioned.volume, "wt", unioned.is_watertight)
    except Exception as e:
        print("filldown union failed, using fill only:", e)
        unioned = fill
    b = unioned.bounds
    e = b[1] - b[0]
    print("print bbox min", [round(x, 2) for x in b[0]])
    print("print bbox max", [round(x, 2) for x in b[1]])
    print("print extents XYZ", [round(x, 2) for x in e])

    OUT.parent.mkdir(parents=True, exist_ok=True)
    export_mesh(unioned, str(OUT), file_type="stl")  # binary ok for Orca; admesh too
    print("wrote", OUT, "bytes", OUT.stat().st_size)
    render_previews(unioned)


if __name__ == "__main__":
    main()
