  width               = 1050
  height              = 625

  # Create patch of triangles that spans the view
  shapeobj = seen.Shapes.tetrahedron()
  shapeback = seen.Shapes.tetrahedron()  

  shape = seen.Shapes.tetrahedron()
  .scale(0.1)
  .translate(0,0,-700)
  .rotx(0)

  model = seen.Models.default().add(shape)

  scene = new seen.Scene
    model    : model
    viewport : seen.Viewports.center(width, height)
    camera   : new seen.Camera
      projection : seen.Projections.ortho()
  
  model.add seen.Lights.directional
    normal    : seen.P(100, 100, -10).normalize()
    color     : seen.Colors.hex('#FFFFFF')
    intensity : 0.008

  model.add seen.Lights.ambient
    intensity : 0.001

  # Load the object file using jquery
  $.get 'assets/logo3D.obj', {}, (contents) ->
  # Create shape from object file
    shapeobj = seen.Shapes.obj(contents, false)
    shapeobj.scale(1).translate(0,0,0).rotx(0).roty(0).rotz(0)
  # Update scene model
  # seen.Colors.randomSurfaces2(shapeobj)
    model.add(shapeobj)

  for surf in shapeobj.surfaces
    surf.originals = surf.points.map (p) -> p.copy()
    surf.fill.color.a = 100 # Add a little transparency

  context = seen.Context('seen-canvas', scene).render()

  t = 0
  context.animate()
    .onBefore((t, dt) ->
      shapeobj.rotx(dt*1e-4)
    )
    .start()

# Enable drag-to-rotate on main viewport
  dragger = new seen.Drag('seen-canvas', {inertia : true})
  dragger.on('drag.rotate', (e) ->
    xform = seen.Quaternion.xyToTransform(e.offsetRelative...)
    seen.Lights.P.x(xform)
    renderAll()
  )