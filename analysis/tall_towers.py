import yt
import sys
import numpy as np
import netCDF4 as nc
import matplotlib.pyplot as plt
from matplotlib.ticker import ScalarFormatter
from mpl_toolkits.axes_grid1 import make_axes_locatable

def plot_amr_level(filetag, atmos_var, land_var, level):
    import yt
    import numpy as np
    import matplotlib.pyplot as plt

    ds = yt.load(f"plt{str(filetag)}")
    lnd = nc.Dataset(f"lnd{str(filetag)}/Level_{str(level).zfill(1)}.nc","r")
 
    if level > ds.index.max_level:
        raise ValueError(f"Requested level {level} exceeds max level {ds.index.max_level}")

    # Get all data
    ad = ds.all_data()

    # Compute min and max
    global_min = ad.min(atmos_var).value
    global_max = ad.max(atmos_var).value

    grids = ds.index.select_grids(level)

    if level < ds.index.max_level:
        grids_children = ds.index.select_grids(level+1)
    else:
        grids_children = []    

    # First pass: collect global min and max for color scaling
    field_slices = []
    global_min = np.Inf
    global_max = -np.Inf

    for g in grids:
        try:
            raw_data = g[('boxlib', atmos_var)].to_ndarray()
        except Exception as e:
            print(f"Error reading field '{atmos_var}' from grid: {e}")
            continue

        # Determine correct slice orientation
        if raw_data.ndim == 3:
            if raw_data.shape[0] < 20:  # z, y, x
                data = raw_data[raw_data.shape[0] // 2, :, :]
            else:  # x, y, z
                data = raw_data[:, :, raw_data.shape[2] // 2]
        elif raw_data.ndim == 2:
            data = raw_data
        else:
            print(f"Unexpected data shape: {raw_data.shape}")
            continue

        global_min = min(global_min,data.min())
        global_max = max(global_max,data.max())

        field_slices.append((g, data))

    # Plot
    #fig, ax = plt.subplots(figsize=(6, 6))
    fig, axes = plt.subplots(nrows=2, ncols=1, figsize=(6, 12))
    ax, ax2 = axes
    for g, data in field_slices:

        dx = g.dds[0].v/1e3
        dy = g.dds[1].v/1e3
        x0 = g.LeftEdge[0].v/1e3
        y0 = g.LeftEdge[1].v/1e3
        nx, ny = data.shape

        x = np.linspace(x0 + dx/2, x0 + dx * nx - dx/2, nx)
        y = np.linspace(y0 + dy/2, y0 + dy * ny - dy/2, ny)
        X, Y = np.meshgrid(x, y, indexing='ij')

        im = ax.pcolormesh(X, Y, data, shading='nearest',
                           cmap='jet', vmin=global_min, vmax=global_max)

    ax.set_title(f"Atmospheric Var: {atmos_var.capitalize()} | AMR Level: {level}")
    ax.set_xlabel("X (km)")
    ax.set_ylabel("Y (km)")

    # Force scientific notation on both axes
    formatter = ScalarFormatter(useMathText=True)
    formatter.set_scientific(True)
    formatter.set_powerlimits((-3, 3))  # triggers sci notation for large/small values
    ax.xaxis.set_major_formatter(formatter)
    ax.yaxis.set_major_formatter(formatter)

    # --- Colorbar on the left ---
    divider = make_axes_locatable(ax)
    cax = divider.append_axes("right", size="5%", pad=0.1)
    cb = fig.colorbar(im, cax=cax, orientation='vertical')

    # Move label to the top
    cb.ax.set_title(atmos_var.capitalize(), pad=10)

    # Flip colorbar ticks to right side (optional, for left placement)
    cb.ax.yaxis.set_label_position('right')
    cb.ax.yaxis.set_ticks_position('right')

    #fig.colorbar(im, ax=ax, orientation='vertical', label=field_name)
    ax.set_aspect('equal', adjustable='box')

    ax2.set_title(f"Land Var: Terrain | AMR Level: {level}")
    lndvar = lnd.variables[land_var.upper()][:]
    ax2.contourf(lndvar[:,:],cmap="terrain",levels=np.linspace(0,2000,200),extend="both")

    ax2.set_xticks([])
    ax2.set_yticks([])
    ax2.set_aspect('equal', adjustable='box')

    # Optional: Draw bounding box for all grids_children
    if any(grids_children):
        xmins = []
        xmaxs = []
        ymins = []
        ymaxs = []

        for g in grids_children:
            xmins.append(g.LeftEdge[0].v / 1e3)
            xmaxs.append(g.RightEdge[0].v / 1e3)
            ymins.append(g.LeftEdge[1].v / 1e3)
            ymaxs.append(g.RightEdge[1].v / 1e3)

        # Compute the union bounds
        x_min = min(xmins)
        x_max = max(xmaxs)
        y_min = min(ymins)
        y_max = max(ymaxs)

        # Width and height
        width = x_max - x_min
        height = y_max - y_min

        # Draw rectangle on plot
        import matplotlib.patches as patches
        rect = patches.Rectangle((x_min, y_min), width, height,
                                 linewidth=1, edgecolor='black', facecolor='none', linestyle='-')
        #rect2 = patches.Rectangle((x_min, y_min), width, height,
        #                         linewidth=1, edgecolor='black', facecolor='none', linestyle='-')
 
        ax.add_patch(rect)
        #ax2.add_patch(rect2)

    plt.tight_layout()
    #plt.show()
    plt.savefig(f'/Users/Akash/Desktop/{level}.png')

if __name__ == "__main__":
    if len(sys.argv) != 5:
        print("Usage: python plot_amrex_level.py <plotfile> <fieldname> <level>")
        print("Example: python plot_amrex_level.py 00000 topography 2")
        sys.exit(1)

    plotfile = sys.argv[1]
    atmosvar = sys.argv[2]
    lndvar = sys.argv[3]
    level = int(sys.argv[4])

    plot_amr_level(plotfile, atmosvar, lndvar, level)
