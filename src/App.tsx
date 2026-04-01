import React, { useState, useEffect, useRef } from 'react';
import { motion, AnimatePresence, useDragControls } from 'motion/react';
import { 
  Home, 
  Settings, 
  Save, 
  Download, 
  Trash2, 
  ChevronDown, 
  Lock, 
  ShieldCheck, 
  Bell, 
  Keyboard,
  Sliders,
  Eye,
  Zap,
  X,
  Code2,
  Copy,
  Check
} from 'lucide-react';

// --- Types ---
type Tab = 'Home' | 'Combat' | 'Visuals' | 'Settings' | 'Source';

interface Notification {
  id: string;
  title: string;
  content: string;
}

// --- Luau Code ---
const LUAU_CODE = `--[[
    ONYX UI LIBRARY (LUAU EDITION)
    A high-fidelity, animated UI library for Roblox.
]]

local Onyx = loadstring(game:HttpGet("https://raw.githubusercontent.com/ajhsjau39/onyx/refs/heads/main/onyx_lib.lua"))()

local Window = Onyx:CreateWindow({
    Name = "Onyx Hub",
    Accent = Color3.fromRGB(244, 181, 209),
    Key = "onyx-dev"
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local SettingsTab = Window:CreateTab("Settings")

-- Combat Features
CombatTab:CreateSection("Aimbot")
CombatTab:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(Value)
        print("Aimbot:", Value)
    end
})

CombatTab:CreateSlider({
    Name = "FOV Radius",
    Min = 0, Max = 800, Default = 150,
    Callback = function(Value)
        print("FOV:", Value)
    end
})

CombatTab:CreateTextBox({
    Name = "Target Player",
    Placeholder = "Username...",
    Callback = function(Text, Enter)
        print("Targeting:", Text)
    end
})

-- Visuals Features
VisualsTab:CreateSection("ESP")
VisualsTab:CreateToggle({
    Name = "Enable ESP",
    Default = true,
    Callback = function(Value)
        print("ESP:", Value)
    end
})

VisualsTab:CreateParagraph("Visuals Info", "ESP allows you to see players through walls. Use responsibly to avoid bans.")

-- Settings
SettingsTab:CreateSection("Interface")
SettingsTab:CreateKeybind({
    Name = "Menu Toggle",
    Default = Enum.KeyCode.F,
    Callback = function()
        print("Menu Toggled")
    end
})

Onyx:Notify("Onyx Hub", "Library loaded successfully!")`;

// --- Components ---

const Divider = ({ label }: { label: string }) => (
  <div className="my-4">
    <div className="flex items-center gap-2 mb-2">
      <span className="text-[10px] font-bold text-accent/70 tracking-widest uppercase">{label}</span>
      <div className="flex-1 h-[1px] bg-white/5" />
    </div>
  </div>
);

const Toggle = ({ label, defaultChecked = false }: { label: string, defaultChecked?: boolean }) => {
  const [enabled, setEnabled] = useState(defaultChecked);
  return (
    <div className="flex items-center justify-between p-2 hover:bg-white/[0.02] rounded-md transition-colors group">
      <span className="text-sm text-neutral-300 group-hover:text-white transition-colors">{label}</span>
      <button 
        onClick={() => setEnabled(!enabled)}
        className={`w-10 h-5 rounded-full relative transition-colors duration-300 ${enabled ? 'bg-accent' : 'bg-neutral-800'}`}
      >
        <motion.div 
          animate={{ x: enabled ? 22 : 2 }}
          className="absolute top-1 w-3 h-3 bg-white rounded-full shadow-sm"
          transition={{ type: 'spring', stiffness: 500, damping: 30 }}
        />
      </button>
    </div>
  );
};

const Slider = ({ label, min = 0, max = 100, defaultValue = 50 }: { label: string, min?: number, max?: number, defaultValue?: number }) => {
  const [value, setValue] = useState(defaultValue);
  return (
    <div className="space-y-2 p-2 hover:bg-white/[0.02] rounded-md transition-colors group">
      <div className="flex justify-between items-center">
        <span className="text-sm text-neutral-300 group-hover:text-white transition-colors">{label}</span>
        <span className="text-xs font-mono text-accent">{value}</span>
      </div>
      <input 
        type="range" 
        min={min} 
        max={max} 
        value={value} 
        onChange={(e) => setValue(parseInt(e.target.value))}
        className="w-full h-1 bg-neutral-800 rounded-lg appearance-none cursor-pointer accent-accent"
      />
    </div>
  );
};

const Dropdown = ({ label, options }: { label: string, options: string[] }) => {
  const [isOpen, setIsOpen] = useState(false);
  const [selected, setSelected] = useState(options[0]);

  return (
    <div className="relative p-2 space-y-2">
      <span className="text-sm text-neutral-300">{label}</span>
      <button 
        onClick={() => setIsOpen(!isOpen)}
        className="w-full flex items-center justify-between bg-[#0a0a0a] border border-white/5 px-3 py-2 rounded-md text-xs text-neutral-400 hover:border-accent/30 transition-all"
      >
        {selected}
        <motion.div animate={{ rotate: isOpen ? 180 : 0 }}>
          <ChevronDown size={14} />
        </motion.div>
      </button>
      <AnimatePresence>
        {isOpen && (
          <motion.div 
            initial={{ opacity: 0, y: -5 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -5 }}
            className="absolute left-2 right-2 top-full mt-1 bg-surface border border-white/10 rounded-md shadow-2xl z-20 overflow-hidden"
          >
            {options.map(opt => (
              <button 
                key={opt}
                onClick={() => { setSelected(opt); setIsOpen(false); }}
                className="w-full text-left px-3 py-2 text-xs text-neutral-400 hover:bg-accent/10 hover:text-accent transition-colors"
              >
                {opt}
              </button>
            ))}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

const Button = ({ label, onClick, onContextMenu }: { label: string, onClick?: () => void, onContextMenu?: (e: React.MouseEvent) => void }) => (
  <button 
    onClick={onClick}
    onContextMenu={onContextMenu}
    className="w-full bg-[#0a0a0a] border border-white/5 p-3 rounded-md text-sm font-medium hover:border-accent/30 transition-all flex items-center justify-between group"
  >
    <span>{label}</span>
    <Zap size={14} className="text-neutral-600 group-hover:text-accent transition-colors" />
  </button>
);

// --- Main App ---

export default function App() {
  const [isLocked, setIsLocked] = useState(true);
  const [key, setKey] = useState('');
  const [activeTab, setActiveTab] = useState<Tab>('Home');
  const [notifications, setNotifications] = useState<Notification[]>([]);
  const [contextMenu, setContextMenu] = useState<{ x: number, y: number, visible: boolean } | null>(null);
  const [keybind, setKeybind] = useState('F');
  const [isSettingKeybind, setIsSettingKeybind] = useState(false);
  const [copied, setCopied] = useState(false);
  
  const dragControls = useDragControls();
  const windowRef = useRef<HTMLDivElement>(null);

  const addNotification = (title: string, content: string) => {
    const id = Math.random().toString(36).substr(2, 9);
    setNotifications(prev => [...prev, { id, title, content }]);
    setTimeout(() => {
      setNotifications(prev => prev.filter(n => n.id !== id));
    }, 4000);
  };

  const handleKeySubmit = () => {
    if (key === 'onyx-dev') {
      setIsLocked(false);
      addNotification('Access Granted', 'Welcome back.');
    } else {
      addNotification('Access Denied', 'Invalid key provided.');
    }
  };

  const handleContextMenu = (e: React.MouseEvent) => {
    e.preventDefault();
    setContextMenu({ x: e.clientX, y: e.clientY, visible: true });
  };

  const copyToClipboard = () => {
    navigator.clipboard.writeText(LUAU_CODE);
    setCopied(true);
    addNotification('Copied', 'Luau code copied to clipboard!');
    setTimeout(() => setCopied(false), 2000);
  };

  useEffect(() => {
    const handleClick = () => setContextMenu(null);
    window.addEventListener('click', handleClick);
    return () => window.removeEventListener('click', handleClick);
  }, []);

  useEffect(() => {
    if (isSettingKeybind) {
      const handleKeyDown = (e: KeyboardEvent) => {
        setKeybind(e.key.toUpperCase());
        setIsSettingKeybind(false);
        addNotification('Keybind Set', `Action bound to ${e.key.toUpperCase()}`);
      };
      window.addEventListener('keydown', handleKeyDown);
      return () => window.removeEventListener('keydown', handleKeyDown);
    }
  }, [isSettingKeybind]);

  const tabs = [
    { id: 'Home', icon: Home },
    { id: 'Combat', icon: Zap },
    { id: 'Visuals', icon: Eye },
    { id: 'Settings', icon: Settings },
    { id: 'Source', icon: Code2 },
  ];

  if (isLocked) {
    return (
      <div className="flex items-center justify-center min-h-screen bg-[#050505]">
        <motion.div 
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="w-80 bg-surface p-8 rounded-xl border border-white/5 shadow-2xl space-y-6 text-center"
        >
          <div className="flex justify-center">
            <div className="w-16 h-16 bg-accent/10 rounded-full flex items-center justify-center border border-accent/20">
              <Lock className="text-accent" size={32} />
            </div>
          </div>
          <div className="space-y-1">
            <h2 className="text-xl font-bold tracking-tight">ONYX HUB</h2>
            <p className="text-xs text-neutral-500">Please enter your access key</p>
          </div>
          <div className="space-y-3">
            <input 
              type="password" 
              placeholder="Enter Key..."
              value={key}
              onChange={(e) => setKey(e.target.value)}
              className="w-full bg-[#0a0a0a] border border-white/5 rounded-md px-4 py-2 text-sm text-center focus:outline-none focus:border-accent/40 transition-colors"
            />
            <button 
              onClick={handleKeySubmit}
              className="w-full bg-accent text-surface font-bold py-2 rounded-md hover:bg-accent/90 transition-colors"
            >
              Check Key
            </button>
            <p className="text-[10px] text-neutral-600">Hint: onyx-dev</p>
          </div>
        </motion.div>
        <NotificationOverlay notifications={notifications} />
      </div>
    );
  }

  return (
    <div className="flex items-center justify-center min-h-screen bg-[#050505] overflow-hidden">
      <motion.div 
        ref={windowRef}
        drag
        dragControls={dragControls}
        dragListener={false}
        dragMomentum={false}
        className="w-[600px] h-[400px] bg-surface rounded-xl border border-white/5 shadow-2xl flex overflow-hidden relative"
      >
        {/* Sidebar */}
        <aside className="w-48 bg-surface border-r border-white/5 flex flex-col">
          <div 
            onPointerDown={(e) => dragControls.start(e)}
            className="p-6 cursor-grab active:cursor-grabbing"
          >
            <h1 className="text-accent font-black tracking-tighter text-2xl">ONYX</h1>
          </div>

          <nav className="flex-1 px-3 space-y-1">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                onClick={() => setActiveTab(tab.id as Tab)}
                className={`w-full flex items-center gap-3 px-4 py-2.5 rounded-md transition-all duration-200 group ${
                  activeTab === tab.id 
                    ? 'bg-accent/10 text-accent' 
                    : 'text-neutral-500 hover:text-neutral-300 hover:bg-white/[0.02]'
                }`}
              >
                <tab.icon size={18} />
                <span className="text-xs font-bold uppercase tracking-wider">{tab.id}</span>
                {activeTab === tab.id && (
                  <motion.div layoutId="sidebar-active" className="ml-auto w-1 h-4 bg-accent rounded-full" />
                )}
              </button>
            ))}
          </nav>

          <div className="p-4 border-t border-white/5">
            <div className="flex items-center gap-3 px-2">
              <div className="w-8 h-8 bg-accent/20 rounded-full flex items-center justify-center border border-accent/30">
                <ShieldCheck size={16} className="text-accent" />
              </div>
              <div className="flex flex-col">
                <span className="text-[10px] font-bold text-neutral-300">ajhsjau39</span>
              </div>
            </div>
          </div>
        </aside>

        {/* Main Content */}
        <main className="flex-1 flex flex-col min-w-0 bg-surface">
          <header 
            onPointerDown={(e) => dragControls.start(e)}
            className="h-14 border-b border-white/5 flex items-center justify-between px-6 cursor-grab active:cursor-grabbing"
          >
            <h2 className="text-sm font-bold text-neutral-200 uppercase tracking-widest">{activeTab}</h2>
            <div className="flex gap-2">
              <button className="p-1.5 text-neutral-500 hover:text-neutral-300 transition-colors"><Bell size={16} /></button>
              <button className="p-1.5 text-neutral-500 hover:text-red-500 transition-colors" onClick={() => setIsLocked(true)}><X size={16} /></button>
            </div>
          </header>

          <div className="flex-1 overflow-y-auto p-6 space-y-2 custom-scrollbar">
            <AnimatePresence mode="wait">
              <motion.div
                key={activeTab}
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: -10 }}
                transition={{ duration: 0.2 }}
              >
                {activeTab === 'Home' && (
                  <div className="space-y-4">
                    <div className="bg-accent/5 border border-accent/10 p-4 rounded-lg">
                      <h3 className="text-accent text-sm font-bold mb-1">Luau UI Library</h3>
                      <p className="text-xs text-neutral-400 leading-relaxed">
                        This interface is a simulation of the Onyx Luau UI Library. 
                        The full source code for the library is available in the "Source" tab.
                      </p>
                    </div>
                    <Divider label="Quick Actions" />
                    <Button 
                      label="Execute Universal Script"
                      onContextMenu={handleContextMenu}
                      onClick={() => addNotification('Executed', 'Universal script executed successfully.')}
                    />
                    <Toggle label="Auto-Execute on Load" />
                    <Toggle label="Anti-AFK System" defaultChecked />
                  </div>
                )}

                {activeTab === 'Combat' && (
                  <div className="space-y-2">
                    <Divider label="Aimbot Settings" />
                    <Toggle label="Enable Aimbot" />
                    <Dropdown label="Target Part" options={['Head', 'Torso', 'HumanoidRootPart']} />
                    <Slider label="FOV Radius" min={0} max={800} defaultValue={150} />
                    <Toggle label="Show FOV Circle" />
                    
                    <Divider label="Kill Aura" />
                    <Toggle label="Enable Aura" />
                    <Slider label="Aura Range" min={1} max={25} defaultValue={12} />
                  </div>
                )}

                {activeTab === 'Visuals' && (
                  <div className="space-y-2">
                    <Divider label="ESP Settings" />
                    <Toggle label="Enable ESP" />
                    <Toggle label="Show Boxes" />
                    <Toggle label="Show Names" />
                    <Toggle label="Show Tracers" />
                    <Dropdown label="Tracer Origin" options={['Bottom', 'Center', 'Mouse']} />
                    
                    <Divider label="World Visuals" />
                    <Toggle label="Fullbright" />
                    <Slider label="Field of View" min={70} max={120} defaultValue={90} />
                  </div>
                )}

                {activeTab === 'Settings' && (
                  <div className="space-y-4">
                    <Divider label="Interface" />
                    <div className="flex items-center justify-between p-2">
                      <span className="text-sm text-neutral-300">Menu Keybind</span>
                      <button 
                        onClick={() => setIsSettingKeybind(true)}
                        className="bg-[#0a0a0a] px-4 py-1.5 rounded-md text-xs font-mono text-accent border border-white/5 hover:border-accent/50 transition-all"
                      >
                        {isSettingKeybind ? 'Press any key...' : keybind}
                      </button>
                    </div>
                    <Toggle label="Enable Notifications" defaultChecked />
                    <Toggle label="Rainbow Accent" />
                    
                    <Divider label="Performance" />
                    <Toggle label="Reduce Lag" />
                    <Toggle label="Disable Shadows" />
                    <Slider label="Graphics Quality" min={1} max={10} defaultValue={5} />

                    <Divider label="Configuration" />
                    <div className="grid grid-cols-3 gap-2">
                      <button className="bg-[#0a0a0a] py-2 rounded-md text-xs font-bold border border-white/5 hover:bg-accent/10 hover:text-accent transition-all">Save</button>
                      <button className="bg-[#0a0a0a] py-2 rounded-md text-xs font-bold border border-white/5 hover:bg-accent/10 hover:text-accent transition-all">Load</button>
                      <button className="bg-[#0a0a0a] py-2 rounded-md text-xs font-bold border border-white/5 hover:bg-red-500/10 hover:text-red-500 transition-all">Reset</button>
                    </div>
                  </div>
                )}

                {activeTab === 'Source' && (
                  <div className="space-y-4 h-full flex flex-col">
                    <div className="flex items-center justify-between">
                      <p className="text-[10px] text-neutral-500 uppercase font-bold tracking-widest">Luau UI Library Source</p>
                      <button 
                        onClick={copyToClipboard}
                        className="flex items-center gap-2 text-[10px] font-bold text-accent hover:text-white transition-colors"
                      >
                        {copied ? <Check size={12} /> : <Copy size={12} />}
                        {copied ? 'COPIED' : 'COPY CODE'}
                      </button>
                    </div>
                    <div className="flex-1 bg-[#050505] p-4 rounded-lg border border-white/5 font-mono text-[11px] text-neutral-400 overflow-auto custom-scrollbar whitespace-pre">
                      {LUAU_CODE}
                    </div>
                  </div>
                )}
              </motion.div>
            </AnimatePresence>
          </div>
        </main>

        {/* Context Menu */}
        <AnimatePresence>
          {contextMenu?.visible && (
            <motion.div 
              initial={{ opacity: 0, scale: 0.95 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.95 }}
              style={{ top: contextMenu.y, left: contextMenu.x }}
              className="fixed bg-[#0a0a0a] border border-white/10 rounded-lg shadow-2xl p-1 z-[100] min-w-[140px]"
            >
              <button className="w-full flex items-center gap-2 px-3 py-2 text-xs text-neutral-300 hover:bg-accent/10 hover:text-accent rounded-md transition-colors">
                <Keyboard size={14} />
                Set Keybind
              </button>
              <button className="w-full flex items-center gap-2 px-3 py-2 text-xs text-neutral-300 hover:bg-accent/10 hover:text-accent rounded-md transition-colors">
                <Sliders size={14} />
                Settings
              </button>
              <div className="h-[1px] bg-white/5 my-1" />
              <button className="w-full flex items-center gap-2 px-3 py-2 text-xs text-red-400 hover:bg-red-500/10 rounded-md transition-colors">
                <Trash2 size={14} />
                Reset Value
              </button>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Subtle background glow */}
        <div className="absolute -top-24 -right-24 w-48 h-48 bg-accent/5 blur-[100px] pointer-events-none" />
        <div className="absolute -bottom-24 -left-24 w-48 h-48 bg-accent/5 blur-[100px] pointer-events-none" />
      </motion.div>

      <NotificationOverlay notifications={notifications} />

      <style>{`
        .custom-scrollbar::-webkit-scrollbar {
          width: 4px;
        }
        .custom-scrollbar::-webkit-scrollbar-track {
          background: transparent;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb {
          background: rgba(255, 255, 255, 0.05);
          border-radius: 10px;
        }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover {
          background: rgba(244, 181, 209, 0.2);
        }
      `}</style>
    </div>
  );
}

function NotificationOverlay({ notifications }: { notifications: Notification[] }) {
  return (
    <div className="fixed top-6 right-6 z-[200] space-y-3 pointer-events-none">
      <AnimatePresence>
        {notifications.map((n) => (
          <motion.div
            key={n.id}
            initial={{ opacity: 0, x: 50, scale: 0.9 }}
            animate={{ opacity: 1, x: 0, scale: 1 }}
            exit={{ opacity: 0, x: 20, scale: 0.9 }}
            className="w-72 bg-surface border border-white/5 p-4 rounded-xl shadow-2xl pointer-events-auto flex gap-4"
          >
            <div className="w-10 h-10 bg-accent/10 rounded-full flex items-center justify-center border border-accent/20 shrink-0">
              <Bell className="text-accent" size={18} />
            </div>
            <div className="space-y-1">
              <h4 className="text-xs font-bold text-white uppercase tracking-wider">{n.title}</h4>
              <p className="text-[11px] text-neutral-500 leading-tight">{n.content}</p>
            </div>
          </motion.div>
        ))}
      </AnimatePresence>
    </div>
  );
}
