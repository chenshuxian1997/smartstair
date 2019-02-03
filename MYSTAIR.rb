require 'sketchup.rb'
class Smart_Stair
	#-------------------------起始值----------------
	def ori#初始值
		@ip=Sketchup::InputPoint.new#起点
		@step=0
		@bntd=false
		@faces=[]
		Sketchup.active_model.selection.clear#清空选择
		@steps=[]
	end

#--------------------复位---------------------------
	def clear#
		@ip.clear
		Sketchup::set_staus_text"智能梯步，起始高度#{@start},梯级#{@step},当前梯级高度#{@height.to_m}米"

	end
#-------------激活-------------------------
	def active
	@start=0.mm
	#--------------inputbox-----------------
	prompts=["起始高度","梯级数目","每梯级高度"]
	defults=[0,0,0]
	$results=inputbox prompts,defaults,"智能梯步"#本质数组
	end
#--------------鼠标启用----------------
	def MouseMove(flag,x,y,view)#传参
	if @bntd#=true
		@ip.pick(view,x,y)
		face=@ip.face
		if face!=nil
			if not facenil face
				Sketchup.active_model.selection.add face#补面
				@faces<<face#左移我也不知道为啥
			end
		end
	end
	end
#--------------------------空面--------------
def facenil(face)
	f=false
	@faces.each{|e|
		if e==face
			f=true
			break
		end
	}
	return a
end
#-------------取消(这是源代码)---------------------
	def onCancel(reason, view)
		Sketchup.active_model.selection.clear
		@faces = []
		if not @steps.empty?
			@step -= @steps.pop
		end
	end
	
#----------------按下按钮-------------------
def onButtonDown(flag,x,y,view)
	@bntd=true
	@ip.pick(view,x,y)
	face=@ip.face
	if face!=nil
		if not facenil face
			Sketchup.active_model.selection.add face
			@faces<<face
		end
	end
end
#------------按钮未按下----------------
def onButtonUp(flag,x,y,view)
	@bntd=false
	if not @faces.empty?#非空面
		model=Sketchup.active_model
		model.start_operation '智能梯步'
	#循环
	@faces.each{|i|#face
		$results[1]+=1
		$results[2]+=1
		i.pullpush $results[0]+$results[1]*$results[2]
	}


	@steps<<$results[1]

	#commit_operation ⇒ Boolean The commit_operation method commits an operation for undo.
	model.commit_operation
	@faces=[]
	model.selection.clear
	Sketchup::set_staus_text"智能梯步，起始高度#{@start},梯级#{@step},当前梯级高度#{@height.to_m}米"
	end
end
#---------------------标识---------------
=begin
def onUserText(text,view)
	begin
		@height=text.to_l
		Sketchup::set_status_text "递增值: #{@hight} "	
	rescue 
		puts""
	end
=end

end#class 
#---------------------------------------图标----------------
#unless file_loaded?(__FILE__)
=begin
	

		# Menu
		@menu.add_item( cmd_Smart_Stair)
		#@menu.add_separator

		# Toolbar
		@toolbar.add_item( cmd_Smart_Stair )
		#@toolbar.add_separator
end # UI
=end
=begin
pmenu=UI.menu("Plugins") #"扩展程序"菜单栏
submenu=pmenu.add_submenu("Smart_Stair") #添加子菜单
submenu.add_item("Smart_Stair"){Smart_Stair}
submenu.add_item("Smart_Stair"){Smart_Stair}
#添加工具栏
toolbar = UI::Toolbar.new "Smart_Stair"

cmd = UI::Command.new("Smart_Stair"){Smart_Stair}
cmd.small_icon =find_png "mystair/stair16.png"
cmd.large_icon =find_png "mystair/stair24.png"
cmd.tooltip = "Smart_Stair"
cmd.status_bar_text = "Smart_Stair"
cmd.menu_text = "Smart_Stair"
toolbar = toolbar.add_item cmd
toolbar.show
=end
def find_png(file_name="") #查找png图片，获取全路径名
	path=Sketchup.find_support_file file_name,"plugins/mystair"
	return path
end
	unless file_loaded?( __FILE__ )      
		cmd_Smart_Stair = UI::Command.new('智能梯步') { Sketchup.active_model.tools.push_tool Smart_Stair.new }
		cmd_Smart_Stair.large_icon =find_png "stair24.png"
		cmd_Smart_Stair.small_icon =find_png "stair16.png"
		cmd_Smart_Stair.tooltip = '智能梯步'
=begin
		@menu = UI.menu('Smart_Stair').add_submenu('智能梯步')
    @toolbar = UI::Toolbar.new('智能梯步')
=end
#@menu = UI::Command.new('Smart_Stair')
	
#	@toolbar = UI::Toolbar.new('智能梯步')
	@tb = UI::Toolbar.new ("Smart_Stair")
	@tb.add_item cmd_Smart_Stair



	@tb.show
	end # UI
	file_loaded( __FILE__ )

 
