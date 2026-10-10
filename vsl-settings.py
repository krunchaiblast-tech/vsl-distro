#!/usr/bin/env python3
"""VSL Settings utility
Simple settings app for trackpad, dock, and camera gestures.
"""

import os
import tkinter as tk
from tkinter import ttk

class VSLSettingsApp:
    def __init__(self, root):
        self.root = root
        self.root.title("VSL Settings")
        self.root.geometry("720x480")
        self.root.minsize(600, 420)

        self.notebook = ttk.Notebook(root)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=16, pady=16)

        self.trackpad_tab = ttk.Frame(self.notebook)
        self.appearance_tab = ttk.Frame(self.notebook)
        self.camera_tab = ttk.Frame(self.notebook)
        self.system_tab = ttk.Frame(self.notebook)

        self.notebook.add(self.trackpad_tab, text="Trackpad")
        self.notebook.add(self.appearance_tab, text="Appearance")
        self.notebook.add(self.camera_tab, text="Camera")
        self.notebook.add(self.system_tab, text="System")

        self.build_trackpad_tab()
        self.build_appearance_tab()
        self.build_camera_tab()
        self.build_system_tab()

    def build_trackpad_tab(self):
        ttk.Label(self.trackpad_tab, text="Trackpad & Gesture Settings", font=("Segoe UI", 14, "bold")).pack(pady=(18, 10))

        options = [
            ("Natural scrolling", True),
            ("Tap to click", True),
            ("Two-finger scroll", True),
            ("Three-finger swipe navigation", True),
            ("Pinch-to-zoom", True),
            ("Mission Control gestures", False),
        ]

        for label, default in options:
            var = tk.BooleanVar(value=default)
            ttk.Checkbutton(self.trackpad_tab, text=label, variable=var).pack(anchor="w", padx=24, pady=4)

        ttk.Label(self.trackpad_tab, text="Tracking speed").pack(anchor="w", padx=24, pady=(12, 0))
        scale = ttk.Scale(self.trackpad_tab, from_=1, to_=10, orient=tk.HORIZONTAL)
        scale.pack(fill=tk.X, padx=24)

    def build_appearance_tab(self):
        ttk.Label(self.appearance_tab, text="Appearance & Dock", font=("Segoe UI", 14, "bold")).pack(pady=(18, 10))

        ttk.Label(self.appearance_tab, text="Theme").pack(anchor="w", padx=24)
        theme_combo = ttk.Combobox(self.appearance_tab, values=["Light Sierra", "Dark Sierra", "Minimal"]) 
        theme_combo.set("Light Sierra")
        theme_combo.pack(fill=tk.X, padx=24)

        ttk.Label(self.appearance_tab, text="Dock transparency").pack(anchor="w", padx=24, pady=(16, 0))
        ttk.Scale(self.appearance_tab, from_=0, to_=100, orient=tk.HORIZONTAL).pack(fill=tk.X, padx=24)

        ttk.Label(self.appearance_tab, text="LCD Glass Preview").pack(anchor="w", padx=24, pady=(16, 0))
        preview = tk.Frame(self.appearance_tab, bg="#dfe7f0", height=110)
        preview.pack(fill=tk.X, padx=24, pady=8)

        dock = tk.Frame(preview, bg="#ffffff", bd=0, highlightthickness=0)
        dock.place(relx=0.08, rely=0.25, relwidth=0.84, height=44)
        dock.configure(bg="#d7e0ee")

    def build_camera_tab(self):
        ttk.Label(self.camera_tab, text="Camera Gesture Controls", font=("Segoe UI", 14, "bold")).pack(pady=(18, 10))

        ttk.Label(self.camera_tab, text="Enable camera gesture recognition").pack(anchor="w", padx=24)
        enabled = tk.BooleanVar(value=False)
        ttk.Checkbutton(self.camera_tab, variable=enabled, text="Use webcam for motion tracking").pack(anchor="w", padx=24, pady=(4, 12))

        ttk.Label(self.camera_tab, text="Sensitivity").pack(anchor="w", padx=24)
        ttk.Scale(self.camera_tab, from_=0, to_=100, orient=tk.HORIZONTAL).pack(fill=tk.X, padx=24)

        ttk.Label(self.camera_tab, text="Privacy note: camera gestures are disabled by default and require explicit consent.", justify=tk.LEFT, wraplength=520).pack(anchor="w", padx=24, pady=(18, 0))

    def build_system_tab(self):
        ttk.Label(self.system_tab, text="System Information", font=("Segoe UI", 14, "bold")).pack(pady=(18, 10))

        info = [
            ("OS", "VSL (Vishwa Sierra Linux)"),
            ("Version", "1.0 Alpha"),
            ("Base", "Debian-based lightweight Linux"),
            ("RAM target", "800MB max in typical desktop use"),
            ("Theme", "Sierra-inspired glass UI"),
        ]

        for label, value in info:
            row = tk.Frame(self.system_tab)
            row.pack(fill=tk.X, padx=24, pady=6)
            tk.Label(row, text=f"{label}:", width=18, anchor="w", font=("Segoe UI", 10, "bold")).pack(side=tk.LEFT)
            tk.Label(row, text=value, anchor="w", fg="#333333").pack(side=tk.LEFT)

if __name__ == "__main__":
    root = tk.Tk()
    app = VSLSettingsApp(root)
    root.mainloop()
